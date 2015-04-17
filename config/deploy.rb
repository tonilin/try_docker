# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'try_docker'
set :repo_url, 'git@github.com:tonilin/try_docker.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/apps/try_docker"

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  after :published, "deploy_docker" do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within current_path do
        upload! "./docker/.env.web", "#{release_path}/docker/.env.web"
        execute 'docker-compose', 'build'
        execute 'docker', 'rmi $(docker images | grep "^<none>" | awk "{print $3}"); true'
        execute 'docker-compose', 'stop'
        execute 'docker-compose', 'up -d'
      end
    end
  end

  desc "Docker restart"
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within current_path do
        execute 'docker-compose', 'stop'
        execute 'docker-compose', 'up -d'
      end
    end
  end
end






