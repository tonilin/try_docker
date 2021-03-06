# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'try_docker'
set :repo_url, 'git@github.com:tonilin/try_docker.git'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/apps/try_docker"


set :release_name, "#{Time.now.utc.strftime("%Y%m%d%H%M%S")}/subdirectory"

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

  after :published, :update_mtime do
    on roles(:web) do
      within current_path do

        ["Gemfile", "Gemfile.lock", "docker/nginx-try-docker.conf", "docker/nginx.conf"].each do |file|
          command = "git rev-list HEAD \"#{file}\" | head -n 1"
          file_revision_hash = `#{command}`
          file_revision_hash.strip!
          command = "git show --pretty=format:%ai --abbrev-commit #{file_revision_hash} | head -n 1"
          file_modified_time = `#{command}`
          execute 'touch', "-d \"#{file_modified_time}\" #{current_path}/#{file}"
        end

      end
    end
  end

  after :update_mtime, :deploy_docker do
    on roles(:web) do
      # Here we can do anything such as:
      within "#{current_path}/docker" do
        upload! "./docker/.env.web", "#{release_path}/docker/.env.web"
        execute 'docker-compose', 'build'
        execute 'docker', 'rmi $(docker images | grep "^<none>" | awk "{print $3}"); true'
        execute 'docker-compose', 'up -d'
      end
    end
  end

  desc "Docker restart"
  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within "#{current_path}/docker" do
        execute 'docker-compose', 'stop'
        execute 'docker-compose', 'up -d'
      end
    end
  end
end






