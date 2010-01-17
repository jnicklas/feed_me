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
        if root = Nokogiri::XML(feed).root
          root.add_namespace_definition('atom', 'http://www.w3.org/2005/Atom')
          parsers.each do |parser|
            node = root.xpath(parser.root_node).first
            if node
              return parser.new(node)
            end
          end
        end
        # if we cannot find a parser, raise an error.
        raise InvalidFeedFormat
      end

    end # class << self

    def initialize(xml)
      @xml = xml
    end

  end

  class AtomFeedParser < FeedParser
    root_node "//atom:feed"

    property :title, :path => 'atom:title'
    property :feed_id, :path => 'atom:id'
    property :description, :path => 'atom:subtitle'
    property :generator, :path => 'atom:generator'
    property :updated_at, :path => 'atom:updated', :as => :time
    property :url, :path => "atom:link[@rel='alternate']", :from => :href
    property :href, :path => "atom:link[@rel='self']", :from => :href

    has_many :entries, :path => 'atom:entry', :use => :AtomItemParser

    has_one :author, :path => 'atom:author', :use => :AtomPersonParser
  end

  class Rss2FeedParser < FeedParser
    root_node "//rss[@version='2.0']/channel"

    property :title
    property :updated_at, :path => :lastBuildDate, :as => :time
    property :feed_id, :path => :undefined
    property :url, :path => :link
    property :href, :path => :undefined
    property :description
    property :generator

    has_many :entries, :path => 'item', :use => :Rss2ItemParser

    has_one :author, :path => 'managingEditor', :use => :Rss2PersonParser
  end
end
