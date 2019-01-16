module Devan
  class Credentials
    attr_reader   :username
    attr_reader   :password
    attr_accessor :proxy
    attr_reader   :verify_ssl

    def initialize(username, password, proxy=nil, verify_ssl=true)
      @username   = username
      @password   = password
      @proxy      = URI.parse(proxy) if proxy
      @verify_ssl = verify_ssl
    end

    def proxy?
      !@proxy.nil?
    end
  end
end
