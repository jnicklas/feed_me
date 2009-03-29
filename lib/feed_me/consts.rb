module FeedMe
  
  ROOT_NODES = {
    :atom => "//feed[@xmlns='http://www.w3.org/2005/Atom']",
    :rss2 => "//rss[@version=2.0]/channel"
  }
  
  ITEM_PROPERTIES = {
    :atom => {
      :title => :title,
      :updated_at => [:updated, :time],
      :item_id => :id,
      :url => ["link[@rel=alternate]", :href],
      :content => :content,
      :author => :special
    },
    :rss2 => {
      :title => :title,
      :updated_at => :undefined,
      :item_id => :guid,
      :url => :link,
      :content => :description,
      :author => :special
    }
  } 
  
  AUTHOR_PROPERTIES = {
    :atom => {
      :email => 'author/email',
      :name => 'author/name',
      :uri => 'author/uri'
    }
  } 
  
end