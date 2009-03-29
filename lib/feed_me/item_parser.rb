module FeedMe
  
  class ItemParser < AbstractParser
  
    attr_accessor :feed
    
    def initialize(xml, format, feed)
      super(xml, format)
      self.feed = feed
    end
  
  end

  class AtomItemParser < ItemParser
    property :title
    property :updated_at, :updated, :as => :time
    property :item_id, :id
    property :url, "link[@rel=alternate]", :from => :href
    property :content
    property :author, :special
    
    def author
      AtomAuthorParser.new(xml, :atom)
    end
  end
  
  class Rss2ItemParser < ItemParser
    
    property :title
    property :updated_at, :undefined
    property :item_id, :guid
    property :url, :link
    property :content, :description
    property :author, :special
    
    def author
      fetch_rss_person("author")
    end
    
  end
end