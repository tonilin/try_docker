FROM ruby:2.2.2

RUN apt-get update
RUN apt-get install -y build-essential

# for nokogiri
RUN apt-get install -y libxml2-dev libxslt1-dev

RUN apt-get install -y imagemagick  libmagickwand-dev

# for postgres
RUN apt-get install -y libpq-dev

# for a JS runtime
RUN apt-get install -y nodejs

# Install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD docker/nginx-try-docker.conf /etc/nginx/sites-enabled/
RUN rm /etc/nginx/sites-enabled/default

# Install foreman
RUN gem install foreman

# WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

ENV APP_HOME /app
RUN mkdir $APP_HOME
COPY . $APP_HOME
WORKDIR $APP_HOME

RUN bundle exec rake assets:precompile --trace

RUN chmod +x ./docker/run.sh

