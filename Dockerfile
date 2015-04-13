FROM ruby:2.2.1
RUN apt-get update -qq && apt-get install -y build-essential nodejs

RUN mkdir /try_docker

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /try_docker
WORKDIR /try_docker
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
CMD ["rails","server","-b","0.0.0.0"]