module Devan
  class Node
    JCR_PRIMARY_TYPE = 'jcr:primaryType'
    JCR_MIXIN_TYPE = 'jcr:mixinTypes'

    class Path
      SEPARATOR = '/'

      class << self
        def split(path)
          path.split(SEPARATOR)
        end

        def join(*args)
          File.join(*args)
        end

        def abs(*args)
          join(SEPARATOR, *args)
        end

        def parent(path)
          File.dirname(path)
        end

        def chomp(path)
          path.chomp(File.extname(path)) 
        end
      end
    end

    def initialize(path, parent, repo)
      @path         = path
      @parent       = parent
      @repo         = repo
      @nodes        = {}
      @properties   = {}
      @types        = {}
      @primaryType  = nil
      @mixins       = []
      @changes      = {}
    end

    def changed?
      @changes.any? || !@nodes.values.detect do |node|
        node.respond_to?(:changed?) && node.changed?
      end.nil?
    end

    def hasNodes?
      @nodes.any?
    end

    def hasNode?(path)
      !@nodes[path].nil?
    end

    def hasProperties?
      @properties.any?
    end

    def getPath
      @path
    end

    def getParent
      @parent
    end

    def addNode(path, type=nil)
      segments = Path.split(path)

      if segments.size > 1
        addNode(segments.shift).addNode(Path.join(*segments), type)
      else
        @nodes[path] ||= (@changes[path] = create(path, type))
      end
    end

    def getNode(path)
      segments = Path.split(path)

      if segments.size > 1
        getNode(segments.shift).getNode(Path.join(*segments))
      else
        @nodes[path] ||= create(path).load()
      end
    end

    def getNodes
      @nodes
    end

    def setPrimaryType(type)
      @changes[JCR_PRIMARY_TYPE] = type
      @primaryType = type
    end

    def getPrimaryNodeType
      @primaryType
    end

    def addMixin(name)
      @changes[JCR_MIXIN_TYPE] ||= []
      @changes[JCR_MIXIN_TYPE] << name

      @mixins << name
    end

    def removeMixin(name)
      @changes[JCR_MIXIN_TYPE].delete(name) if @changes[JCR_MIXIN_TYPE]
      @mixins.delete(name)
    end

    def setProperty(name, value)
      @changes[name] = value
      @properties[name] = value
    end

    def getProperty(name)
      @properties[name]
    end

    def getProperties
      @properties
    end

    protected

    def create(path, type=nil)
      node = Node.new(Path.join(getPath(), path), self, getRepo())
      node.setPrimaryType(type) if type
      node
    end

    def load
      parse(getRepo().export(getPath()))
    end

    def serialize
      data = {}

      @changes.each do |k, v|
        next if v.nil? || (v.respond_to?(:size) && v.size == 0)

        if v.respond_to? :serialize
          v.serialize.each do |kk, vv|
            data[Path.abs(k, kk)] = vv
          end
        else
          data[k] = v
        end
      end

      mixins = data[JCR_MIXIN_TYPE]
      if mixins.is_a?(Array) && mixins.any?
        data[JCR_MIXIN_TYPE] = Devan::Value.new(mixins, 'name')
      end

      data
    end

    def parse(data)
      data.each do |k, v|
        if k.include?(':')
          if k.start_with?(':')
            @types[k[1..-1]] = v
          else
            @properties[k] = v
          end
        else
          @nodes[k] = nil
        end
      end

      @primaryType = @properties.delete(JCR_PRIMARY_TYPE)
      @mixins = @properties.delete(JCR_MIXIN_TYPE)

      self
    end

    def clear
      @changes = {}

      @nodes.each do |k, v|
        v.clear if v.respond_to?(:clear)
      end

      self
    end

    def getRepo
      @repo
    end
  end
end
