class FeedMe::AbstractParser
  
  class << self
    
    attr_accessor :properties, :root_nodes
    
    def build(xml, format)
      # in a world with activesupport this would have been written as
      #   format_parser = (format.to_s.camelize + self.to_s).constantize
      camelized_format = format.to_s.split('_').map{ |w| w.capitalize }.join('')
      bare_class = self.to_s.split('::').last
      
      begin
        format_parser = FeedMe.const_get(camelized_format + bare_class)
        if format_parser.is_a?(Class) and format_parser.ancestors.include?(self)
          format_parser.new(xml)
        else
          self.new(xml, format)
        end
      rescue NameError
        self.new(xml, format)
      end
    end
    
  end

  def initialize(xml, format = nil)
    self.xml = xml
    self.format = format
    self.properties = self.class.properties
    
    append_methods
  end
  
  attr_accessor :xml, :format, :properties

  alias_method :root_node, :xml
  
  protected
  
  def append_methods
    self.properties[format].each do |method, p|
      unless respond_to?(method)
        block = get_proc_for_property(p)
        # meta programming magic
        (class << self; self; end).module_eval do
          define_method method, &block
        end
      end
    end
  end
  
  def get_proc_for_property(p)
    if p.class == Array
      return proc { fetch("/#{p[0]}", root_node, p[1].to_sym) }
    elsif p != :undefined
      return proc { fetch("/#{p}", root_node) }
    else
      return proc { nil }
    end
  end

  def property(name)
    self.properties[format][name]
  end

  def fetch(selector, search_in = xml, method = :inner_html)
    item = search_in.at(selector)
    item[method] or item.try(method) if item
  end
  
end