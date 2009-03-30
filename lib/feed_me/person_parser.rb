module FeedMe

  class AtomPersonParser < AbstractParser

    property :email, :path => 'author/email'
    property :name, :path => 'author/name'
    property :uri, :path => 'author/uri'

  end

  class Rss2PersonParser
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
