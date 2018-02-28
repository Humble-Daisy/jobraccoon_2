# # Load DSL and Setup Up Stages
# require 'capistrano/setup'
# require 'capistrano/deploy'
#     require "capistrano/scm/git"
#     install_plugin Capistrano::SCM::Git
#
# require 'capistrano/rails'
# require 'capistrano/bundler'
# require 'capistrano/rvm'
# require 'capistrano/puma'
# install_plugin Capistrano::Puma
set :rbenv_type, :user
set :rbenv_ruby, '2.5.0'

# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rails'
require 'capistrano/bundler'
require 'capistrano/rbenv'
require 'capistrano/puma'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Nginx

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
