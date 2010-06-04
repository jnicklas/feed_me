module FeedMe

  class PersonParser < AbstractParser; end

  class AtomPersonParser < PersonParser
    property :email, :path => 'atom:email'
    property :name, :path => 'atom:name'
    property :uri, :path => 'atom:uri'
  end

  class Rss2PersonParser < PersonParser
    attr_reader :uri

    def email
      xml.text.split(/\s+/, 2)[0] if xml
    end

    def name
      xml.text.split(/\s+/, 2)[1].to_s[/\((.*?)\)/, 1] if xml
    end
  end

  class Rss1PersonParser < PersonParser
    property :email, :path => :undefined
    property :name, :path => 'dc:creator'
    property :uri, :path => :undefined
  end

end
