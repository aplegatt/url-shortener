require 'sequel'

DB = Sequel.connect(ENV['DATABASE_URL'])

unless DB.tables.include?(:urls)
  DB.create_table :urls do
    primary_key :id
    String :long_url, null: false
    String :short_url, null: false
  end
end
