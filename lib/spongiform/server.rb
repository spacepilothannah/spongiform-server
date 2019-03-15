require 'roda'
require 'spongiform/db'

unless ENV['SPONGIFORM_PASSWD_FILE']
  puts 'You must specify a password file for authentication in SPONGIFORM_PASSWD_FILE'
  exit 1
end

require 'spongiform/auth'

Spongiform::Auth.passwd_file = ENV['SPONGIFORM_PASSWD_FILE']
