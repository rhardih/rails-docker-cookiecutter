#!/usr/bin/env bash

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -x  Print commands and their arguments as they are executed.
# -o option-name
#   pipefail     the return value of a pipeline is the status of
#                the last command to exit with a non-zero status,
set -euxo pipefail

# Generate a new Rails project set up to use a PostgreSQL as a databaes and with
# tailwindcss for styles.
#
# Override entrypoint, as we don't need to clean up previous pids, and can't run
# anything related to db: yet.
docker compose run --entrypoint= --no-deps web rails new . \
  --force --database=postgresql --css tailwind

# The default web: task on the generated Procfile doesn't bind to 0.0.0.0, to
# escape running in a docker container, so we append it manually
sed -i'' -e '/server -p 3000/ s/$/ -b 0.0.0.0/' Procfile.dev

# Change owner of all files to current user
chown -R "$USER" .

# Build the image
docker compose build

# Fix config/database.yml with template
docker compose run --entrypoint= --no-deps web rails app:template LOCATION=fix-database-config.rb

# No need for it to stay after generation
rm fix-database-config.rb

# Build and push the image, so the project can be instantly deploy after
# creation
docker compose build
docker compose push
