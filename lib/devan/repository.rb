module Devan
  class Repository
    JCR_ROOT = 'jcr:root'
    CRX_DEFAULT_WORKSPACE = 'crx.default'

    attr_reader :url
    attr_reader :credentials
    attr_reader :workspace

    def initialize(url)
      @url        = url
      @credentials= nil
      @workspace  = nil
      @path       = nil
      @username   = nil
    end

    def login(credentials, workspace=nil)
      @credentials  = credentials
      @workspace    = workspace || CRX_DEFAULT_WORKSPACE
      @path         = Node::Path.abs('crx', 'server', self.workspace, CGI.escape(JCR_ROOT).downcase)
      @root         = nil

      getRootNode().send(:load).hasNodes?
    end

    def logout
      @credentials  = nil
      @workspace    = nil
      @path         = nil
      @root         = nil
    end

    def getPath
      @path
    end

    def getRootNode
      @root ||= Node.new(Node::Path::abs, nil, self)
    end

    def getNode(path)
      getRootNode().getNode(path)
    end

    def activateNode(path, opts={})
      if opts.delete(:recursive)
        client.activateTree(Node::Path.abs(path), opts)
      else
        client.activate(Node::Path.abs(path), opts)
      end
    end

    def deactivateNode(path, opts={})
      if opts.delete(:recursive)
        raise ArgumentError, 'Tree deactivation is not available.'
      else
        client.deactivate(Node::Path.abs(path), opts)
      end
    end

    def removeNode(path)
      client.delete(Node::Path.abs(path))
    end

    def save
      node = getRootNode()

      if node.changed?
        if import(node.getPath(), node.send(:serialize))
          node.send(:clear)
          true
        else
          false
        end
      else
        true
      end
    end

    def import(*args)
      client.post(*expand_path_args(*args))
    end

    def export(*args)
      client.get(*expand_path_args(*args)) || {}
    end

    protected

    def expand_path_args(*args)
      [Node::Path.join(getPath(), args.shift), *args]
    end

    def client
      @client ||= Devan::Client.new(url,
                                    credentials.username, 
                                    credentials.password,
                                    credentials.proxy)
    end
  end
end
