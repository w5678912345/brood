require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :user , 'root'
set :domain, '115.29.196.16'
set :deploy_to, '/root/www/bigger'
set :repository, 'ubuntu@test_bolt.dabi.co:repo/dabi.git'
set :branch, 'master'

set :rvm_path, '/usr/local/rvm/scripts/rvm' 
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'tmp/pids','log','config/thin.yml','config/secrets.yml']


# thin settings
set_default :thin_cmd, 'thin'
set_default :thin_config, 'config/thin.yml'

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
  invoke :'rvm:use[ruby-2.0.0-p247@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]

  queue! %[touch "#{deploy_to}/shared/config/thin.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/thin.yml'."]
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
    #queue %[cp -f dabi_worker.thrift public]
    to :launch do
      invoke :'thin:stop'
      invoke :'thin:start'
      #queue "touch #{deploy_to}/tmp/restart.txt"
    end
  end
end
namespace :thin do
  [:start, :stop, :restart].each do |cmd|
    desc "#{cmd} thin"
    task cmd => :environment do
     queue %[echo "-----> #{cmd} thin..."]
     queue! %[cd "#{deploy_to}/#{current_path}" && \
      #{ thin_cmd } -C "#{ thin_config }" #{ cmd }]
    end
  end
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

