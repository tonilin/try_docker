FROM ruby:2.2.2

RUN apt-get update

# for a JS runtime
RUN apt-get install -y nodejs

# Install foreman
RUN gem install foreman

# Install nginx
RUN apt-get install -y nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/default
ADD docker/nginx-try-docker.conf /etc/nginx/sites-enabled/
ADD docker/nginx.conf /etc/nginx/

# WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

ENV APP_HOME /app
COPY . $APP_HOME
WORKDIR $APP_HOME

RUN chmod +x ./docker/run.sh

