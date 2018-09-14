module App
  class Requests < Roda
    plugin :json
    plugin :json_parser

    route do |r|
      r.root do
        # list all 
        r.get do

        end

        # make request (this is redirected from the error page)
        r.post do
        end
      end

      r.on Integer do
        r.is do
          r.get do

          end

          r.put do

          end
        end
      end

    end
  end
end
