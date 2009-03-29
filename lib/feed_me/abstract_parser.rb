class FeedMe::AbstractParser
  
  class << self

    def properties
      @properties ||= {}
    end

    def property(name, *args)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options[:path] ||= args.empty? ? name.to_s : args.first

      properties[name.to_sym] = options

      class_eval <<-RUBY
        def #{name}
          get_property(:#{name})
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
  
  def get_property(name)
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