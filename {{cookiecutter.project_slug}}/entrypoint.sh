#!/usr/bin/env bash

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
set -eu

# Remove a potentially pre-existing server.pid for Rails.
rm -f /{{cookiecutter.project_slug}}/tmp/pids/server.pid

postgres_password_file=/run/secrets/{{cookiecutter.postgres_password_secret_name}}

export {{cookiecutter.project_name|upper|replace(' ', '_')}}_DATABASE_PASSWORD=$(cat "$postgres_password_file")

# Allow the "or" to work in the fallback below
set +e

# Run migrations or create the db if it doesn't yet exist (migration fails)
bin/rails db:migrate || bin/rails db:setup db:seed

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
