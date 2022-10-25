#!/usr/bin/env sh

# -e  Exit immediately if a command exits with a non-zero status.
# -u  Treat unset variables as an error when substituting.
# -x  Print commands and their arguments as they are executed.
set -eux

# Install gems with bundler and precompile assets.

# When initially building the image, e.g. when running `rails new`, the
# necessary files have not yet been generated, hence the guards.

if [ -f "bin/rails" ]
then
  bin/bundle install
fi

if [ -f "bin/rails" -a -f "app/assets/stylesheets/application.tailwind.css" ]
then
  bin/rails assets:precompile
fi
