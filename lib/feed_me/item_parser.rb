module FeedMe
  
  class ItemParser < AbstractParser
  
    self.properties = ITEM_PROPERTIES
    
    attr_accessor :feed
    
    def initialize(feed, xml, format = nil)
      super(xml, format)
      self.feed = feed
    end
  
  end
end