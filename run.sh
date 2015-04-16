#!/bin/bash

bundle install --without development test &&\
RAILS_ENV=production bundle exec rake assets:precompile --trace &&\
foreman start