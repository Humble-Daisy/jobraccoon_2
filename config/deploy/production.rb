# Change these
# server '35.227.87.83', port: 22, roles: [:web, :app, :db], primary: true
#
# set :repo_url,        'git@github.com:mickn/seeker.git'
# set :application,     'seeker'
# set :user,            'mick'
# set :puma_threads,    [4, 16]
# set :puma_workers,    0
#
# # Don't change these unless you know what you're doing
# set :pty,             true
# set :use_sudo,        false
# set :stage,           :production
# set :deploy_via,      :remote_cache
# set :deploy_to,       "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
# set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
# set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
# set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
# set :puma_access_log, "#{release_path}/log/puma.error.log"
# set :puma_error_log,  "#{release_path}/log/puma.access.log"
# set :ssh_options,     { forward_agent: true, user: fetch(:user), keys: %w(~/.ssh/id_rsa.pub) }
# set :puma_preload_app, true
# set :puma_worker_timeout, nil
# set :puma_init_active_record, false  # Change to true if using ActiveRecord

server "159.203.3.130", user: 'deployer', roles: %w{app db web}
set :stage, :production
set :branch, :master
set :deploy_user, "deployer"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/pedagogically_website"
set :branch, 'master'
set :rails_env, 'production'
set :puma_env, "production"
set :puma_conf, "#{shared_path}/config/puma.rb"
