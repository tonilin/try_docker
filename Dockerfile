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

# Install nginx
RUN apt-get install -qq -y nginx

# Install foreman
RUN gem install foreman


WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

ENV APP_HOME /try_docker
RUN mkdir $APP_HOME
ADD . $APP_HOME
WORKDIR $APP_HOME
CMD bundle exec rake assets:precompile --trace
