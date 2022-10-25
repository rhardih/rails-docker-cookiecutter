#!/usr/bin/env bash

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -x  Print commands and their arguments as they are executed.
# -o option-name
#   pipefail     the return value of a pipeline is the status of
#                the last command to exit with a non-zero status,
set -euxo pipefail

# Generate a new Rails project, which is set up to use PostgreSQL as a database
# and tailwindcss for styles.
#
# The entrypoint is overridden because there's no need to wait for a db or to
# clean up previous pids etc. in this case.
#
# N.B.: Running `rails new` with the --skip-bundle would allow us to avoid
# having to bundle again when we build the image, but unfortunately it doesn't
# *just* skip bundling. It skips other necessary steps, so it's needless, but
# unavoidable, double work. 
docker compose run --no-deps --entrypoint= web \
  rails new . \
  --database=postgresql \
  --css={{cookiecutter.css_framework}}

# The default Procfile doesn't allow connections from anything but localhost, so
# this fixes the command
sed -i '' -e '/server -p 3000/ s/$/ -b 0.0.0.0/' Procfile.dev

# Since this is running on an alpine based image, update bin/dev as to use sh
# instead of bash.
sed -i '' -e 's/bash/sh/g' bin/dev

# Change owner of all files to current user
chown -R "$USER" .

# Build the container so all gems are present in the image as well
docker compose build web

# Fix config/database.yml with template
docker compose run --no-deps --entrypoint= web \
  rails app:template LOCATION=fix-database-config.rb

# Cleanup the file, since it's no longer needed
rm fix-database-config.rb
