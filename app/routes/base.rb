module App
  class Base < Roda
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
        r.run App::Domains
      end
      r.is 'domains' do
        r.run App::Domains
      end

      r.on 'requests' do
        r.run App::Requests
      end
      r.is 'requests' do
        r.run App::Domains
      end
    end
  end
end
