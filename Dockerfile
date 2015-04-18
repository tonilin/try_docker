FROM ruby:2.2.2

RUN apt-get update

# for a JS runtime
RUN apt-get install -y nodejs

# Install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD docker/nginx-try-docker.conf /etc/nginx/sites-enabled/
ADD docker/gzip.conf /etc/nginx/conf.d/
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

ENV RAILS_ENV production

RUN ["sh", "-c", "\"RAILS_ENV=$RAILS_ENV bundle exec rake assets:precompile --trace\""]

RUN chmod +x ./docker/run.sh

