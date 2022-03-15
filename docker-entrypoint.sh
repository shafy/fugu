#!/bin/bash
set -e

# create database if it doesn't exist
rails db:create

# run migrations if necessary
rails db:migrate

# create initial user if env vars are set and user doesn't exist
if [ -n "${INIT_USER_EMAIL}" ] && [ -n "${INIT_USER_PASSWORD}" ] && [ "$(rails runner "puts User.exists?(email: '${INIT_USER_EMAIL}')")" = 'false' ]
then
  echo "Creating initial user..."
  rails runner "User.create!({email: '${INIT_USER_EMAIL}', password: '${INIT_USER_PASSWORD}', password_confirmation: '${INIT_USER_PASSWORD}', status: 'active' })"
fi

exec "$@"
