module App
  class Base < Roda
    plugin :json
    plugin :json_parser

    route do |r|
      response['Content-Type'] = 'application/json'
      r.root do
        puts 'root'

        r.on 'simple' do
          puts 'simple'
          'Hey!'
        end


        r.on 'domains' do
          r.run App::Domains
        end
        r.on 'requests' do
          r.run App::Requests
        end
      end
    end
  end
end
