module Devan
  class RootNode < Node
    def activate
      true
    end

    def deactive
      true
    end

    def children
      @children ||= process_children(client.fetch(path + '/', 1))
    end

    def load
      @children = nil
      @changes = {}
      @properties = client.fetch(path + '/')
      process_properties!
    end

    def save
      @changes = {}
      true
    end

    def delete
      false
    end

    def node(p)
      node = Node.new(p.split('/').last, {}, self, [path, p].join('/'))
      node.load
      node
    end
  end
end
