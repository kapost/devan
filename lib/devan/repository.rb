module Devan
  class Repository
    JCR_ROOT = 'jcr:root'

    attr_reader :url
    attr_reader :workspace
    attr_reader :root

    def initialize(url, workspace=nil)
      @url = url
      @workspace = workspace || 'crx.default'
      @root = nil
    end

    def login(username, password)
      @client = Client.new([@url, crx_server_path].join('/'), username, password)
      @root = RootNode.new(JCR_ROOT, {}, self, "/#{crx_server_path}")
      @root.load
    end

    protected

    def crx_server_path
      @crx_server_url ||= ['crx', 'server', @workspace, CGI.escape(JCR_ROOT).downcase].join('/')
    end

    def client
      @client
    end
  end
end
