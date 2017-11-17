#!/usr/bin/env bash
GEMFILE="Gemfile"
GEMS_CACHE="./gems"

if [ ! -e "$GEMFILE" ]; then
  cat >"$GEMFILE" <<EOL
  source 'https://rubygems.org'

  gem 'eventide-postgres'
  gem 'evt-component_host'
EOL
fi

bundle install --standalone --path="$GEMS_CACHE"

# create database
evt-pg-create-db
