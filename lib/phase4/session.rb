require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    def initialize(req)
      @req = req
      @cookie = req.cookies.find { |c| c.name == '_rails_lite_app'}
      @session_hash = @cookie ? JSON.parse(@cookie.value) : {}
    end

    def [](key)
      @session_hash[key]
    end

    def []=(key, val)
      @session_hash[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      res.cookies << WEBrick::Cookie.new('_rails_lite_app', @session_hash.to_json)
    end
  end

  class Flash
    def initialize(session)
      @session = session
      @session[:flash] ||= {}
      @now = {}
    end

    def [](key)
      @session[:flash][key]
    end

    def []=(key, val)
      @session[:flash][key] = val
    end

    def now
      @now
    end

    def now=(val)
      @now = val
    end

    def store_session(res)
      self['now'] = @now
      @session.store_session(res)
    end
  end
end
