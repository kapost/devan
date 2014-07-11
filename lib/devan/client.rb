module Devan
  class Client
    class HTTPClient
      include HTTMultiParty
      headers 'User-Agent' => VERSION_STRING
#      debug_output $stdout
    end

    attr_reader :url
    attr_reader :username
    attr_reader :password
    attr_reader :proxy

    def initialize(url, username, password, proxy=nil)
      @url      = url
      @username = username
      @password = password
      @proxy    = proxy
    end

    def activate(path, opts={})
      replicate({ :cmd => 'activate', :path => path }.merge!(opts))
    end

    def deactivate(path, opts={})
      replicate({ :cmd => 'deactivate', :path => path }.merge!(opts))
    end

    def activateTree(path, opts={})
      replicateTree({ :cmd => 'activate', :path => path }.merge!(opts))
    end

    def deactivateTree(path, opts={})
      replicateTree({ :cmd => 'deactivate', :path => path }.merge!(opts))
    end

    def delete(path)
      !parse_response { http.post(path, :body => { ':operation' => 'delete' }) }.nil?
    end

    def get(path, depth=0)
      parse_response { http.get("#{path}.#{depth}.json") }
    end

    def post(path, body={}) 
      !parse_response { http.post(path, :body => body) }.nil?
    end

    protected

    def replicate(params)
      !parse_response do
        body = { :_charset => 'utf-8' }.merge!(params)
        http.post('/bin/replicate.json', :body => body)
      end.nil?
    end

    def replicateTree(params)
      !parse_response do
        body = { :_charset => 'utf-8', :ignoredeactivated => 'true', :onlymodified => 'true' }.merge!(params)
        http.post('/etc/replication/treeactivation.html', :body => body)
      end.nil?
    end

    def parse_response
      response = yield

      raise Error.new(response.body, response.code) unless response.code / 10 == 20

      if response.parsed_response.is_a? Hash
        response.parsed_response
      elsif response.body.to_s.strip[0] == '<'
        response.body
      elsif response.body.to_s.size > 0
        JSON.parse(response.body)
      else
        response.body.to_s
      end
    end

    def http
      @http ||= begin
        client = self
        Class.new(HTTPClient) do |klass|
          klass.base_uri(client.url.to_s)
          klass.basic_auth(client.username, client.password)

          if proxy = client.proxy
            klass.http_proxy(proxy.host, proxy.port, proxy.user, proxy.password)
          end
        end
      end
    end
  end
end

