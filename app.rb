require 'roda'

require_relative 'db'

Dir[__dir__ + '/app/**/*.rb'].each do |rb|
  require rb
end
