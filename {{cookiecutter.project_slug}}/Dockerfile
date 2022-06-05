# syntax=docker/dockerfile:1

FROM ruby:{{cookiecutter.ruby_version}}-alpine

# Use latest RubyGems
RUN gem update --system

# postgresql-client - To get pg_isready binary
# libpq-dev - Requirement for compiling pg gem
# tzdata - To avoid error: 'TZInfo::DataSourceNotFound: tzinfo-data is not
#          present', when precompiling assets
RUN apk add --update --no-cache \
  build-base \
  libpq-dev \
  nodejs \
  postgresql-client \
  tzdata

WORKDIR /{{cookiecutter.project_slug}}

# Copy entire project
COPY . /{{cookiecutter.project_slug}}/

RUN bundle install

# Precompile assets (but skip if we're generating a new project, and bin/rails
# doesn't exist yet)
RUN if [ -f "bin/rails" ]; then bin/rails assets:precompile; fi

EXPOSE 3000

ENTRYPOINT ["./entrypoint.sh"]

# Configure the main process to run when running the image
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
