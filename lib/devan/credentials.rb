module Devan
  class Credentials
    attr_reader   :username
    attr_reader   :password
    attr_accessor :proxy

    def initialize(username, password, proxy=nil)
      @username = username
      @password = password
      @proxy    = URI.parse(proxy) if proxy
    end

    def proxy?
      !@proxy.nil?
    end
  end
end
