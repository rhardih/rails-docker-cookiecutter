#!/usr/bin/env bash

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -x  Print commands and their arguments as they are executed.
# -o option-name
#   pipefail     the return value of a pipeline is the status of
#                the last command to exit with a non-zero status,
set -euxo pipefail

# Remove a potentially pre-existing server.pid for Rails.
rm -f /{{cookiecutter.project_slug}}/tmp/pids/server.pid

postgres_password_file=/run/secrets/{{cookiecutter.postgres_password_secret_name}}

export {{cookiecutter.project_name|upper|replace(' ', '_')}}_DATABASE_PASSWORD=$(cat "$postgres_password_file")

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
