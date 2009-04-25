module FeedMe

  class PersonParser < AbstractParser; end

  class AtomPersonParser < PersonParser

    property :email
    property :name
    property :uri

  end

  class Rss2PersonParser
    attr_reader :name, :email, :uri, :xml

    def initialize(feed, xml)
      @feed = feed
      @xml = xml
      if(xml)
        @email, @name = xml.inner_html.split(/\s+/, 2)
        @name = name.match( /\((.*?)\)/ ).to_a[1] if @name # strip parentheses
      end
    end
  end

end
