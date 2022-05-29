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
