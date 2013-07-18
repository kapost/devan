module Devan
  class Node
    attr_reader :name
    attr_reader :parent
    attr_reader :properties

    attr_accessor :changes

    def initialize(name, properties, parent, path=nil)
      @name = name
      @properties = properties || {}
      @parent = parent
      @path = path
      @children = nil
      @changes = {}

      process_properties!
    end

    def add(name, properties={})
      child = Node.new(name, {}, self)
      child.changes = properties
      child.save

      @children << child if @children

      child
    end

    def update_attributes(attrs)
      @changes.merge!(attrs)
      save
    end

    def set(name, value)
      @changes[name] = value
    end

    def get(name)
      @changes[name] || @properties[name]
    end

    def children
      @children ||= process_children(client.fetch(path, 1))
    end

    def activate
      client.activate(path)
    end

    def deactivate
      client.deactive(path)
    end

    def load
      @children = nil
      @changes = {}
      @properties = client.fetch(path)
      process_properties!
    end

    def save
      if @changes.size > 0
        client.store(path, @changes)
        self.load
      end
    end

    def delete
      client.delete(path)
    end

    def find(name)
      children.find { |child| child.name == name }
    end

    def path
      @path ||= [parent.path, @name].join('/')
    end

    def to_s
      p = properties.map do |k, v|
        "#{k.inspect}=#{v.inspect}"
      end.join(', ')

      "<#{self.class}: @name=#{name.inspect}, @properties={#{p}}>"
    end

    protected

    def process_properties!
      @properties.reject! do |k, v|
        v.is_a? Hash or v.is_a? Array
      end
    end

    def process_children(properties)
      properties.reject! do |k, v|
        !v.is_a? Hash
      end

      properties.map do |k, v|
        Node.new(k, v, self)
      end
    end

    def client
      @client ||= parent.send(:client)
    end
  end
end
