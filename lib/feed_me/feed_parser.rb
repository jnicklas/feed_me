module FeedMe

  class FeedParser < AbstractParser

    class << self

      def root_node(node=nil)
        @root_node = node if node
        @root_node
      end

      def parsers
        @parsers ||= []
      end

      def inherited(subclass)
        super
        parsers << subclass
      end

      def open(file)
        self.parse(Kernel.open(file).read)
      end

      # parses the passed feed and identifeis what kind of feed it is
      # then returns a parser object
      def parse(feed)
        xml = Hpricot.XML(feed)
        parsers.each do |parser|
          node = xml.at(parser.root_node)
          return parser.new(node) if node
        end
      end

    end

  end

  class AtomFeedParser < FeedParser
    root_node "//feed[@xmlns='http://www.w3.org/2005/Atom']"

    property :title
    property :feed_id, :path => :id
    property :description, :path => :subtitle
    property :generator
    property :author, :path => :undefined
    property :entries, :path => :undefined
    property :updated_at, :path => :updated, :as => :time
    property :url, :path => "link[@rel=alternate]", :from => :href
    property :href, :path => "link[@rel=self]", :from => :href

    def entries
      xml.search('entry').map do |el|
        AtomItemParser.new(el, self)
      end
    end

    def author
      AtomPersonParser.new(xml)
    end
  end

  class Rss2FeedParser < FeedParser
    root_node "//rss[@version=2.0]/channel"

    property :title
    property :updated_at, :path => :lastBuildDate, :as => :time
    property :feed_id, :path => :undefined
    property :url, :path => :link
    property :href, :path => :undefined
    property :description
    property :generator
    property :author, :path => :undefined
    property :entries, :path => :undefined

    def entries
      xml.search('item').map do |el|
        Rss2ItemParser.new(el, self)
      end
    end

    def author
      Rss2PersonParser.new(xml, "managingEditor")
    end
  end
end
