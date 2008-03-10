module FeedMe
  
  ROOT_NODES = {
    :atom => "//feed[@xmlns='http://www.w3.org/2005/Atom']",
    :rss2 => "//rss[@version=2.0]/channel"
  }
  
  FEED_PROPERTIES = {
    :atom => {
      :title => :title,
      :updated_at => :updated,
      :feed_id => :id,
      :url => ["link[@rel=alternate]", :href],
      :href => ["link[@rel=self]", :href],
      :generator => :generator
    },
    :rss2 => {
      :title => :title,
      :updated_at => :lastBuildDate,
      :feed_id => :undefined,
      :url => :link,
      :href => :undefined,
      :generator => :generator,
      :author => {
        :email => :author
      }
    }
  }
  
  ITEM_PROPERTIES = {
    :atom => {
      :title => :title,
      :updated_at => :updated,
      :item_id => :id,
      :url => ["link[@rel=alternate]", :href],
      :content => :content
    },
    :rss2 => {
      :title => :title,
      :updated_at => :undefined,
      :item_id => :guid,
      :url => :link,
      :content => :description
    }
  }  
  
end