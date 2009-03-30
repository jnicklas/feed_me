class FeedMe::AbstractParser

  class << self

    def properties
      @properties ||= {}
    end

    def has_many_associations
      @has_many_associations ||= {}
    end

    def has_one_associations
      @has_one_associations ||= {}
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
      has_many_associations[name.to_sym] = options

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{name}
          get_has_many_association(:#{name})
        end
      RUBY
    end

    def has_one(name, options={})
      raise ArgumentError, "must specify :use option" unless options[:use]
      options[:path] ||= name
      has_one_associations[name.to_sym] = options

      class_eval <<-RUBY, __FILE__, __LINE__+1
        def #{name}
          get_has_one_association(:#{name})
        end
      RUBY
    end

  end

  def initialize(xml)
    self.xml = xml
  end

  def to_hash
    hash = {}
    self.class.properties.each do |method, p|
      hash[method] = self.send(method)
    end
    return hash
  end

  attr_accessor :xml

  alias_method :root_node, :xml

private

  def get_has_many_association(name)
    return nil unless xml
    association = self.class.has_many_associations[name]
    
    nodes = xml.search(association[:path])
    parser = FeedMe.const_get(association[:use].to_s)
    
    nodes.map do |node|
      parser.new(node, self)
    end
  end

  def get_has_one_association(name)
    return nil unless xml
    association = self.class.has_one_associations[name]
    
    node = xml.at("/#{association[:path]}")
    parser = FeedMe.const_get(association[:use].to_s)
    
    parser.new(node, self)
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
      DateTime.parse(result)
    else
      result
    end
  end

end
