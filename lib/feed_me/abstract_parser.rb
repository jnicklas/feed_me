class FeedMe::AbstractParser

  class << self

    def properties
      @properties ||= {}
    end

    def property(name, options={})
      options[:path] ||= name
      properties[name.to_sym] = options

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{name}
          get_property(:#{name})
        end
      RUBY
    end

    def has_many(name, options={})
      raise ArgumentError, "must specify :use option" unless options[:use]
      options[:path] ||= name
      options[:association] = :has_many
      properties[name.to_sym] = options

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{name}
          get_has_many_association(:#{name})
        end
      RUBY
    end

    def has_one(name, options={})
      raise ArgumentError, "must specify :use option" unless options[:use]
      options[:path] ||= name
      options[:association] = :has_one
      properties[name.to_sym] = options

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{name}
          get_has_one_association(:#{name})
        end
      RUBY
    end

  end

  def initialize(feed, xml)
    @xml = xml
    @feed = feed
  end

  def to_hash
    hash = {}
    self.class.properties.each do |method, p|
      hash[method] = self.send(method)
    end
    return hash
  end

  attr_reader :xml, :feed

  alias_method :root_node, :xml

private

  def get_has_many_association(name)
    return nil unless xml
    association = self.class.properties[name]
    
    nodes = xml.search(association[:path])
    parser = FeedMe.const_get(association[:use].to_s)
    
    nodes.map do |node|
      parser.new(self, node)
    end
  end

  def get_has_one_association(name)
    return nil unless xml
    association = self.class.properties[name]
    
    node = xml.at("/#{association[:path]}")
    parser = FeedMe.const_get(association[:use].to_s)
    
    parser.new(self, node)
  end

  def get_property(name)
    return nil unless xml
    property = self.class.properties[name]

    node = xml.at("/#{property[:path]}")

    if node
      result = extract_result(node, property[:from])
      result = cast_result(result, property[:as])
    end
  end

  def extract_result(node, from)
    if from
      node[from]
    else
      node.inner_html
    end
  end

  def cast_result(result, as)
    if as == :time
      Time.parse(result)
    else
      result
    end
  end

end
