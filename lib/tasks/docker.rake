namespace :docker do
  task :restart => ['docker:stop', 'docker:up']

  task :build => :environment do
    sh 'docker-compose build'
    `docker images -q --filter "dangling=true" | xargs docker rmi`
  end

  task :up => :environment do
    sh 'docker-compose up -d'
  end

  task :stop => :environment do
    sh 'docker-compose stop'
  end

end