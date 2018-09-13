require 'roda'
require_relative 'db'

class App < Roda
  route do |r|
    r.root do
      r.is '' do
      end

      r.on 'domains' do
        r.is do
          # get all domains
          r.get do
          end
          r.post do
          end
        end

        r.on Integer do
          r.put do

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

App.freeze.run
