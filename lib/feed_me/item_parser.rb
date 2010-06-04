module FeedMe

  class ItemParser < AbstractParser; end

  class AtomItemParser < ItemParser
    property :title, :path => 'atom:title'
    property :updated_at, :path => "atom:updated", :as => :time
    property :item_id, :path => "atom:id"
    property :url, :path => "atom:link[@rel='alternate']", :from => :href
    property :content, :path => 'atom:content'

    has_one :author, :path => 'atom:author', :use => :AtomPersonParser
  end

  class Rss2ItemParser < ItemParser
    property :title
    property :updated_at, :path => :pubDate, :as => :time
    property :item_id, :path => :guid
    property :url, :path => :link
    property :content, :path => :description
    property :categories, :path => :category, :cardinality => :many

    has_one :author, :use => :Rss2PersonParser
  end

  class Rss1ItemParser < ItemParser
    property :title, :path => 'rss1:title'
    # property :updated_at, :path => :pubDate, :as => :time
    property :item_id, :path => '@rdf:about'
    property :url, :path => 'rss1:link'
    # property :content, :path => :description
    # property :categories, :path => :category, :cardinality => :many
    #
    # has_one :author, :use => :Rss2PersonParser

    def xml
      resource = super.xpath('@rdf:resource').to_s
      super.xpath("//rss1:item[@rdf:about='#{resource}']").first
    end
  end
end
