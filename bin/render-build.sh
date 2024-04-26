#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate

# Check if the admin user exists
if ! bundle exec rails runner "User.exists?(email: ENV['ADMIN_EMAIL'])"
then
  bundle exec rails runner "User.create!(email: ENV['ADMIN_EMAIL'], password: ENV['ADMIN_PASSWORD], admin: true)"
fi