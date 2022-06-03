# syntax=docker/dockerfile:1

FROM ruby:{{cookiecutter.ruby_version}}

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /{{cookiecutter.project_slug}}

COPY Gemfile /{{cookiecutter.project_slug}}/Gemfile
COPY Gemfile.lock /{{cookiecutter.project_slug}}/Gemfile.lock

# For subsequent builds after generation
COPY . /{{cookiecutter.project_slug}}/

RUN gem update --system
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
