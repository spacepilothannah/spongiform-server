require 'sequel'

unless ENV['SQUIDDO_DATABASE']
  puts 'You must specify a database connection string in SQUIDDO_DATABASE env var'
  exit 1
end

DB = Sequel.connect(ENV['SQUIDDO_DATABASE'])

Sequel::Model.plugin :timestamps

Dir[__dir__ + '/db/*.rb'].each do |model|
  require model
end
