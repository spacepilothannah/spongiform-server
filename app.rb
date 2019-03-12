require 'roda'

require_relative 'db'

unless ENV['SPONGIFORM_PASSWD_FILE']
  puts 'You must specify a password file for authentication in SPONGIFORM_PASSWD_FILE'
  exit 1
end


Dir[__dir__ + '/app/services/*.rb'].each do |rb|
  require rb
end
Dir[__dir__ + '/app/**/*.rb'].each do |rb|
  require rb
end

Auth.passwd_file = ENV['SPONGIFORM_PASSWD_FILE']
