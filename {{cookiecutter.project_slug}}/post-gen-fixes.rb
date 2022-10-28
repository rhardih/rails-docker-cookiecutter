# This is a Rails application template:
# https://guides.rubyonrails.org/rails_application_templates.html

# Fix the host, username & password, so it corresponds to the db container
inject_into_file 'config/database.yml', after: "pool: <%= ENV.fetch(\"RAILS_MAX_THREADS\") { 5 } %>\n" do
  <<-'YML'
  host: db
  username: postgres
  password: password
  YML
end

# Set hosts to allow requests in a production deploy
inject_into_file 'config/environments/production.rb',
 after: "config.active_record.dump_schema_after_migration = false\n" do  <<-'RUBY'

  # Allow requests through the ActionDispatch::HostAuthorization middleware
  config.hosts = ["{{cookiecutter.domain}}"]
  RUBY
end
