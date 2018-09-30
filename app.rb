require 'roda'

require_relative 'db'

unless ENV['SQUIDDO_PASSWD_FILE']
  puts 'You must specify a password file for authentication in SQUIDDO_PASSWD_FILE'
  exit 1
end

Dir[__dir__ + '/app/services/*.rb'].each do |rb|
  require rb
end
Dir[__dir__ + '/app/**/*.rb'].each do |rb|
  require rb
end
