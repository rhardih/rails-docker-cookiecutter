#!/usr/bin/env bash

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -x  Print commands and their arguments as they are executed.
# -o option-name
#   pipefail     the return value of a pipeline is the status of
#                the last command to exit with a non-zero status,
set -euxo pipefail

# Generate a new Rails project
docker compose run --no-deps web rails new . --force --database=postgresql

# Change owner of all files to current user
chown -R "$USER" .

# Build the image
docker compose build

# Fix config/database.yml with template
docker compose run web bin/rails app:template LOCATION=fix-database-config.rb

# No need for it to stay after generation
rm fix-database-config.rb

# Spin up PostgreSQL 
docker compose up -d db

# Wait for 10 seconds and then create the database
sleep 10
docker compose run web rake db:create

# Spin down PostgreSQL again
docker compose down
