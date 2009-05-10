module FeedMe

  class ItemParser < AbstractParser; end

  class AtomItemParser < ItemParser
    property :title
    property :updated_at, :path => :updated, :as => :time
    property :item_id, :path => :id
    property :url, :path => "link[@rel=alternate]", :from => :href
    property :content

    has_one :author, :use => :AtomPersonParser
  end

  class Rss2ItemParser < ItemParser
    property :title
    property :updated_at, :path => :pubDate, :as => :time
    property :item_id, :path => :guid
    property :url, :path => :link
    property :content, :path => :description

    has_one :author, :use => :Rss2PersonParser
  end
end
