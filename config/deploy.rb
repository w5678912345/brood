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
set :tian,'test_tianyi.dabi.co'
set :bolt,'54.199.199.189'
set :domain, bolt
set :deploy_path, 'apps/test_bolt.dabi.co/current'

set :target ,ENV["TARGET"]

set :rvm_path, '/home/ubuntu/.rvm/bin/rvm' #'/usr/local/rvm/scripts/rvm'

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
set :user, 'ubuntu'

desc "deploy to server. use like this: mina r_deploy TARGET=[bolt,tian1,tian2,...]"
task :r_deploy do
  invoke :'rvm:use[ruby-2.0.0-p247]'
  queue! %[cd #{deploy_path}]
  queue! %[pwd]
  #queue %[#{target}]
  queue! %[mina shutdown -f config/deploy-#{target}.rb]
  queue! %[mina deploy -f config/deploy-#{target}.rb]
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

