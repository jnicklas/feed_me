module FeedMe
  
  class AtomAuthorParser < AbstractParser
  
    property :email, 'author/email'
    property :name, 'author/name'
    property :uri, 'author/uri'
  
  end
  
  class Rss2AuthorParser
    attr_reader :name, :email, :uri
  
    def initialize(xml, selector)
      item = xml.at("/#{selector}")
      if(item)
        @email, @name = item.inner_html.split(/\s+/, 2)
        @name = name.match( /\((.*?)\)/ ).to_a[1] if @name # strip parentheses
      end
    end
  end

end