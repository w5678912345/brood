#
# 发布应用分支 master 到服务器
#
# 使用用法：
#   部署：mina deploy -f config/deploy-local.rb -v
#   停止：mina shutdown -f config/deploy-local.rb -v
#   其他命令参见：mina tasks
#
# **************
# 警告：为了减少必须要的错误, 部署前请先确保应用已经被停止
# **************10
#
# 运行命令后输出 “in `write': Broken pipe (Errno::EPIPE)”，忽略即可
#

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
require 'mina/whenever'

set_default :term_mode, :pretty
# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '127.0.0.1' #'ec2-54-242-118-120.compute-1.amazonaws.com'
set :deploy_to, '/home/suxu/www/broot.com'
set :user, 'suxu'

set :rails_env, 'production'

set :repository, 'ubuntu@ec2-54-242-118-120.compute-1.amazonaws.com:apps/brood.git'
set :branch, 'master'
set :rvm_path, '/home/suxu/.rvm/scripts/rvm' #'/usr/local/rvm/scripts/rvm'

# thin settings
set_default :thin_cmd, 'thin'
set_default :thin_config, 'config/thin.yml'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_config_files, ['config/database.yml',settings.thin_config]

set :shared_paths, ['log', 'public/uploads'] + settings.shared_config_files

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  invoke :'rvm:use[1.9.3]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  #queue! %[chmod g+rx,u+rwx "#{deploy_to}"]

  # queue! %[mkdir -p "#{deploy_to}/current"]
  # queue! %[chmod g+rx,u+rwx "#{deploy_to}/current"]

  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[mkdir -p "#{deploy_to}/shared/public/uploads"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/public/uploads"]
  
  settings.shared_config_files.each do |config|
    queue! %[touch "#{deploy_to}/shared/#{config}"]
  end
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'


    to :launch do
      invoke :'thin:start'
      # invoke :'resque:start'
      # invoke :'whenever:write'
    end
    
    to :clean do
      invoke :shutdown
    end
  end
end

desc "Restart app."
task :restart do
 queue %[echo "-----> Restarting..."]
 invoke :'thin:restart'
 invoke :'resque:restart'
 invoke :'whenever:update'
end

desc "Shutdown app."
task :shutdown do
  queue %[echo "-----> Shutting down..."]
  invoke :'rvm:use[ruby-1.9.3]'
  invoke :'thin:stop'
end

namespace :thin do
  [:start, :stop, :restart].each do |cmd|
    desc "#{cmd} thin"
    task cmd => :environment do
     queue %[echo "-----> #{cmd} thin..."]
     queue! %[cd "#{deploy_to}/#{current_path}" && \
      #{ thin_cmd } -e #{ rails_env } -C "#{ thin_config }" #{ cmd }]
    end
  end
end


namespace :db  do
  task :seed => :environment do
    queue! %[cd #{deploy_to}/#{current_path} && #{rake} db:seed]
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
