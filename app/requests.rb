module App
  class Requests < Roda
    plugin :json
    plugin :json_parser
    plugin :all_verbs
    plugin :typecast_params
    plugin :render, engine: 'haml'
    plugin :halt
    
    alias_method :tp, :typecast_params

    route do |r|
      r.is '' do
        # get requests API
        r.get do
          case r.params['allowed']
          when 'true'
            Request.allowed.map &:to_hash
          when 'false'
            Request.denied.map &:to_hash
          when nil
            if r.params['pending']
              Request.pending.map &:to_hash
            else
              Request.all.map &:to_hash
            end
          end
        end

        # make request (this is redirected from the error page)
        r.post do
          url = r.params['url']
          r.halt 400 if url.nil?

          begin
            @request = Request.create(url: url)
            view 'requests/created'
          rescue Sequel::ValidationFailed
            @request = Request.pending.where(url: url).first
            response.status = 400
            view 'requests/pending_already_exists'
          end
        end
      end

      # page redirected to by squidguard
      r.is 'not_on_whitelist' do 
          view 'requests/not_on_whitelist'
      end

      r.on Integer do |id|
        request = Request.find(id)
        halt 404 unless request

        r.get do
          # status pagoe
          view 'requests/status'
        end

        r.put do
          allowed = tp.bool('allow')
          if allowed
            # add domain to whitelist

          elsif !allowed
            # mark request as denied
            request.denied_at
          end
        end
      end
    end
  end
end
