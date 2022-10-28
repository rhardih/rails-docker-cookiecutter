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
