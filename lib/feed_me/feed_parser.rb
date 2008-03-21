module FeedMe
  
  class FeedParser < AbstractParser
  
    self.properties = FEED_PROPERTIES
  
    def self.open(file)
      self.parse(Kernel.open(file).read)
    end
    
    # parses the passed feed and identifeis what kind of feed it is
    # then returns a parser object
    def self.parse(feed)
      xml = Hpricot.XML(feed)
    
      root_node, format = self.identify(xml)
      self.build(root_node, format)
    end
  
    def self.identify(xml)
      FeedMe::ROOT_NODES.each do |f, s|
        item = xml.at(s)
        return item, f if item
      end
    end
  end
  
  class AtomFeedParser < FeedParser
    self.properties = FEED_PROPERTIES
  end
  
  class Rss2FeedParser < FeedParser
    self.properties = FEED_PROPERTIES
    
    def author
      fetch_rss_person("managingEditor")
    end
  end
end