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


## Defaults:
# set :scm,           :git
# set :branch,        :master
# set :format,        :pretty
# set :log_level,     :debug
# set :keep_releases, 5

## Linked Files & Directories (Default None):
# set :linked_files, %w{config/database.yml}
# set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :linked_files, fetch(:linked_files, []).push('.env')
set :linked_files, %w{config/puma.rb config/master.key config/database.yml config/global_config.yml}
set :linked_dirs,  %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :linked_dirs, fetch(:linked_dirs, []).push('public/packs', 'node_modules')

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:app) do
      unless `git rev-parse HEAD` == `git rev-parse origin/master`
        puts "WARNING: HEAD is not the same as origin/master"
        puts "Run `git push` to sync changes."
        exit
      end
    end
  end

  desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Upload to shared/config'
  task :upload do
  on roles (:app) do
    upload! "config/master.key",  "#{shared_path}/config/master.key"
    upload! "config/puma.sample.rb",  "#{shared_path}/config/puma.rb"
    upload! "config/database.yml", "#{shared_path}/config/database.yml"
    upload! "config/global_config.yml", "#{shared_path}/config/global_config.yml"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :starting,     :check_revision
  after  :finishing,    :compile_assets
  after  :finishing,    :cleanup
  after  :finishing,    :restart
end

# ps aux | grep puma    # Get puma pid
# kill -s SIGUSR2 pid   # Restart puma
# kill -s SIGTERM pid   # Stop puma
