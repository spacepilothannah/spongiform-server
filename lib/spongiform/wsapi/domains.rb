require 'spongiform/auth'

module Spongiform
  class Domains < Roda
    plugin :json, classes: [Hash,Array]
    plugin :json_parser
    plugin :all_verbs
    plugin :slash_path_empty
    plugin :basic_auth, authenticator: Auth.method(:ok?), realm: 'Spongiform API'

    route do |r|
      r.basic_auth
      r.root do 
        r.get do
          Domain.map(&:to_hash)
        end
      end

      r.on String do |domain_name|
        r.post do
          Domain.find_or_create(domain: domain_name).to_hash
        end

        r.delete do
          domain = Domain.where(domain: domain_name)
          halt if domain.nil?
          domain.delete
          nil
        end
      end
    end
  end
end
