require 'spongiform/server'
require 'spongiform/server/domains'
require 'spongiform/server/requests'

module Spongiform
  class WSAPI < Roda
    plugin :json
    plugin :json_parser

    route do |r|
      response['Content-Type'] = 'application/json'

      r.on 'simple' do
        request.each_header do |h|
          puts h.inspect
        end
        'Hey!'
      end


      r.on 'domains' do
        r.run Domains
      end
      r.is 'domains' do
        r.run Domains
      end

      r.on 'requests' do
        r.run Requests
      end
      r.is 'requests' do
        r.run Requests
      end
    end
  end
end
