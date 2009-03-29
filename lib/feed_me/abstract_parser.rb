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
  
  def self.property(name, *args)
    options = args.last.is_a?(Hash) ? args.pop : {}
    
    options[:path] ||= args.empty? ? name.to_s : args.first
    
    if options[:as]
      block = proc { fetch("/#{options[:path]}", root_node, options[:as]) }
    elsif options[:from]
      block = proc { fetch("/#{options[:path]}", root_node, options[:from]) }
    elsif options[:path] != :undefined
      block = proc { fetch("/#{options[:path]}", root_node) }
    else
      block = proc { nil }
    end
    
    define_method name, &block
    @properties ||= {}
    @properties[name] = options
  end
  
  protected
  
  def fetch_rss_person(selector)
    item = fetch(selector)
    if(item)
      email, name = item.split(/\s+/, 2)
      name = name.match( /\((.*?)\)/ ).to_a[1] if name # strip parentheses
    else
      name, email = nil
    end
    FeedMe::SimpleStruct.new(:email => email, :name => name, :uri => nil)
  end

  def fetch(selector, search_in = xml, method = :inner_html)
    item = search_in.at(selector)
    
    self.try("extract_" + method.to_s, item) if item
  end
  
  def extract_inner_html(item)
    item.inner_html
  end
  
  def extract_href(item)
    item[:href]
  end
  
  def extract_time(item)
    DateTime.parse(item.inner_html)
  end
  
end