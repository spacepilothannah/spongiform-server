require 'sequel'

DB = Sequel.sqlite(integer_booleans: true)

Dir[__dir__ + '/db/*.rb'].each do |model|
  require model
end
