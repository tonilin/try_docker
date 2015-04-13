FROM ruby:2.2.1

RUN apt-get update -qq
RUN apt-get install -qq -y build-essential nodejs
RUN apt-get install -qq -y imagemagick  libmagickwand-dev libmagickcore-dev

RUN mkdir /try_docker

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /try_docker
WORKDIR /try_docker
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
CMD ["rails","server","-b","0.0.0.0"]