# syntax=docker/dockerfile:1

FROM ruby:{{cookiecutter.ruby_version}}

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

WORKDIR /{{cookiecutter.directory_name}}

COPY Gemfile /{{cookiecutter.directory_name}}/Gemfile
COPY Gemfile.lock /{{cookiecutter.directory_name}}/Gemfile.lock

RUN gem update --system
RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
