module FeedMe
  
  class FeedParser < AbstractParser
  
    class << self
    
      def open(file)
        self.parse(Kernel.open(file).read)
      end
    
      # parses the passed feed and identifeis what kind of feed it is
      # then returns a parser object
      def parse(feed)
        xml = Hpricot.XML(feed)
    
        root_node, format = self.identify(xml)
        self.build(root_node, format)
      end
      
      protected
  
      def identify(xml)
        FeedMe::ROOT_NODES.each do |f, s|
          item = xml.at(s)
          return item, f if item
        end
      end
    
    end
  end
  
  class AtomFeedParser < FeedParser
    property :title
    property :feed_id, :id
    property :description, :subtitle
    property :generator
    property :author, :special
    property :entries, :special
    property :updated_at, :updated, :as => :time
    property :url, "link[@rel=alternate]", :from => :href
    property :href, "link[@rel=self]", :from => :href
    
    def entries
      xml.search('entry').map do |el|
        ItemParser.build(el, self.format, self)
      end
    end
    
    def author
      AtomAuthorParser.new(xml, :atom)
    end
  end
  
  class Rss2FeedParser < FeedParser
    property :title
    property :updated_at, :lastBuildDate, :as => :time
    property :feed_id, :undefined
    property :url, :link
    property :href, :undefined
    property :description
    property :generator
    property :author, :special
    property :entries, :special
    
    def entries
      xml.search('item').map do |el|
        ItemParser.build(el, self.format, self)
      end
    end
    
    def author
      fetch_rss_person("managingEditor")
    end
  end
end