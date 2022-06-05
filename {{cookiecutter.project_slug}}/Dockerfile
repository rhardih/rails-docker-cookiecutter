# syntax=docker/dockerfile:1

FROM ruby:{{cookiecutter.ruby_version}}

# Use latest RubyGems
RUN gem update --system

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

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
