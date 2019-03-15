require 'sequel'

unless ENV['SPONGIFORM_DATABASE']
  puts 'You must specify a database connection string in SPONGIFORM_DATABASE env var'
  exit 1
end

DB = Sequel.connect(ENV['SPONGIFORM_DATABASE'])

Sequel::Model.plugin :timestamps

Dir[__dir__ + '/db/*.rb'].each do |model|
  require model
end
