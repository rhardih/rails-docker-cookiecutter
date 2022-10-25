# syntax=docker/dockerfile:1

# This Dockerfile creates an image that can both be the basis for generating a
# new Rails project, but also run the same project locally for development and
# in a production deploy.

FROM ruby:{{cookiecutter.ruby_version}}-alpine

# These packages are needed for the below `rails new` command to succeed:
#
# build-base - Compilers needed for gems with native extensions
# libpq-dev - Requirement for building the pg gem, which is a dependency, if
# using --database=postgresql
# tzdata - To avoid error: 'TZInfo::DataSourceNotFound: tzinfo-data is not
# present', when precompiling assets
# 
# These packages are needed when running the application:
#
# postgresql-client - Needed for pg_isready used in entrypoint.sh
# git - Used in generating initial .gitignore
RUN apk add --update \
  build-base \
  libpq-dev \
  tzdata \
  postgresql-client \
  git

# Use latest RubyGems
RUN gem update --system

# The foreman gem is installed as well here, because it would otherwise be
# installed *on-demand*, every time the container is re-created subsequently.
# Foreman is used in development to run the tailwindcss watcher and the rails
# server under one supervisor process.
RUN gem install rails foreman

WORKDIR /{{cookiecutter.project_slug}}

# Copy entire project
COPY . /{{cookiecutter.project_slug}}/

RUN ./cmd/build.sh

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
