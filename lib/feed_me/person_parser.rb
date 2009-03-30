module FeedMe

  class PersonParser < AbstractParser
    attr_accessor :feed

    def initialize(xml, feed)
      super(xml)
      self.feed = feed
    end

  end

  class AtomPersonParser < PersonParser

    property :email
    property :name
    property :uri

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
