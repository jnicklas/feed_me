class FeedMe::AbstractParser
  
  class << self
    
    attr_accessor :properties, :root_nodes
    
    def build(xml, format, *args)
      # in a world with activesupport this would have been written as
      #   format_parser = (format.to_s.camelize + self.to_s).constantize
      camelized_format = format.to_s.split('_').map{ |w| w.capitalize }.join('')
      bare_class = self.to_s.split('::').last
            
      begin
        format_parser = FeedMe.const_get(camelized_format + bare_class)
      rescue NameError
      end

      if format_parser.is_a?(Class) and format_parser.ancestors.include?(self)
        return format_parser.new(xml, format, *args)
      else
        return self.new(xml, format, *args)
      end

    end
    
  end

  def initialize(xml, format)
    self.xml = xml
    self.format = format
    self.properties = self.class.properties
  end
  
  def to_hash
    hash = {}
    self.properties.each do |method, p|
      hash[method] = self.send(method)
    end
    return hash
  end
  
  attr_accessor :xml, :format, :properties

  alias_method :root_node, :xml
  
  def self.root_node(node=nil)
    @root_node = node if node
    @root_node
  end
  
  def self.property(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    options[:path] ||= args.empty? ? name.to_s : args.first
    
    @properties ||= {}
    @properties[name.to_sym] = options
    
    class_eval <<-RUBY
      def #{name}
        get_property(:#{name})
      end
    RUBY
  end
  
  protected
  
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
  
  def fetch_rss_person(selector)
    item = xml.at("/#{selector}")
    if(item)
      email, name = item.inner_html.split(/\s+/, 2)
      name = name.match( /\((.*?)\)/ ).to_a[1] if name # strip parentheses
    else
      name, email = nil
    end
    FeedMe::SimpleStruct.new(:email => email, :name => name, :uri => nil)
  end
  
end