FROM ruby:2.2.1

RUN apt-get update -qq
RUN apt-get install -qq -y build-essential

# for nokogiri
RUN apt-get install -qq -y libxml2-dev libxslt1-dev

RUN apt-get install -qq -y imagemagick  libmagickwand-dev

# for postgres
RUN apt-get install -qq -y libpq-dev

# for a JS runtime
RUN apt-get install -qq -y nodejs

RUN mkdir /try_docker

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install

ADD . /try_docker
WORKDIR /try_docker
RUN RAILS_ENV=production bundle exec rake assets:precompile --trace
