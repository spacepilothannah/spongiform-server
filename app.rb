require 'roda'
require_relative 'db'
require_relative 'domainlist'

class App < Roda
  route do |r|
    r.root do
      plugin :json
      plugin :json_parser

      r.is '' do
      end

      r.on 'domains' do
        r.is do
          # get all domains
          r.get do
          end
        end

        r.on String do |domain_name|
          r.post do
            puts env['roda.json_params'].inspect
            domain = Domain.find_or_create(domain: domain_name)
            domain.save
            domain
          end
        end
      end

      r.on 'requests' do
        r.is do
          # list all domains (to authenticated user)
          r.get do
            # filter out o

          end

          # 
          r.post do
          end
        end

        r.on Integer do
          r.is do
            r.put do
                  
            end
          end
        end
      end
    end
  end
end
