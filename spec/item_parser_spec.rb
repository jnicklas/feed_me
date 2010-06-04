require File.join( File.dirname(__FILE__), "spec_helper" )

require 'feed_me'

describe FeedMe::ItemParser do

  before :each do
    @atom_feed = FeedMe::FeedParser.open(fixture('welformed.atom'))
    @atom = @atom_feed.entries.first
    @rss2_feed = FeedMe::FeedParser.open(fixture('welformed.rss2'))
    @rss2 = @rss2_feed.entries.first
    @rss1_feed = FeedMe::FeedParser.open(fixture('welformed.rss1'))
    @rss1 = @rss1_feed.entries.first
  end

  describe '#to_hash' do
    it "should serialize the parsed properties to a hash" do

    end
  end

  describe '#title' do
    it "should be valid for an atom feed" do
      @atom.title.should == "First title"
    end

    it "should be valid for an rss2 feed" do
      @rss2.title.should == "Star City"
    end

    it "should be valid for an rss1 feed" do
      @rss1.title.should == "Processing Inclusions with XSLT"
    end
  end

  describe '#content' do
    it "should be valid for an atom feed" do
      @atom.content.should == "Here be content"
    end

    it "should be valid for an rss2 feed" do
      @rss2.content.should == "This is content"
    end

    it "should be valid for an rss1 feed" do
      @rss1.content.should == "Processing document inclusions with general XML tools can be problematic."
    end
  end

  describe '#item_id' do
    it "should be valid for an atom feed" do
      @atom.item_id.should == "tag:imaginary.host,2008-03-07:nyheter/3"
    end

    it "should be valid for an rss2 feed" do
      @rss2.item_id.should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
    end

    it "should be valid for an rss1 feed" do
      @rss1.item_id.should == "http://xml.com/pub/2000/08/09/xslt/xslt.html"
    end
  end

  describe '#updated_at' do
    it "should be valid for an atom feed" do
      @atom.updated_at.should == Time.utc( 2008, 3, 7, 20, 41, 10 )
    end

    it "should be valid for an rss2 feed" do
      @rss2.updated_at.should == Time.utc(2003, 6, 3, 9, 39, 21)
    end

    it "should be taken from dublin core for an rss1 feed" do
      @rss1.updated_at.should == Time.utc(2010, 6, 3, 10, 7, 42)
    end
  end

  describe '#url' do
    it "should be valid for an atom feed" do
      @atom.url.should == "http://imaginary.host/posts/3"
    end

    it "should be valid for an rss2 feed" do
      @rss2.url.should == "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"
    end

    it "should be valid for an rss1 feed" do
      @rss1.url.should == "http://google.com/foobar"
    end
  end

  describe '#categories' do
    it "should be correct for an rss2 feed" do
      @rss2.categories.should == ['news', 'chuck']
    end
  end

  describe '#author.name' do
    it "should be valid for an atom feed" do
      @atom.author.name.should == "Jonas Nicklas"
    end

    it "should be valid for an rss2 feed" do
      @rss2.author.name.should == "Chuck Norris"
    end

    it "should be taken from dublin core for an rss1 feed" do
      @rss1.author.name.should == "akeri.se"
    end
  end

  describe '#author.email' do
    it "should be valid for an atom feed" do
      @atom.author.email.should == "jonas.nicklas@imaginary.host"
    end

    it "should be valid for an rss2 feed" do
      @rss2.author.email.should == "da_man@example.com"
    end

    it "should be nil for an rss1 feed" do
      @rss1.author.email.should be_nil
    end
  end

  describe '#author.uri' do
    it "should be valid for an atom feed" do
      @atom.author.uri.should == "http://imaginary.host/students/jnicklas"
    end

    it "should be nil for an rss2 feed" do
      @rss2.author.uri.should be_nil
    end

    it "should be nil for an rss1 feed" do
      @rss1.author.uri.should be_nil
    end
  end

  describe '#to_hash' do

    it "should serialize the title for an atom feed" do
      @atom.to_hash[:title].should == "First title"
    end

    it "should serialize the item_id for an atom feed" do
      @atom.to_hash[:item_id].should == "tag:imaginary.host,2008-03-07:nyheter/3"
    end

    it "should serialize updated_at for an atom feed" do
      @atom.to_hash[:updated_at].should == Time.utc( 2008, 3, 7, 20, 41, 10 )
    end

    it "should serialize the url for an atom feed" do
      @atom.to_hash[:url].should == "http://imaginary.host/posts/3"
    end

    it "should serialize the author of an atom feed" do
      author = @atom.to_hash[:author]

      author.name.should == "Jonas Nicklas"
      author.email.should == "jonas.nicklas@imaginary.host"
      author.uri.should == "http://imaginary.host/students/jnicklas"
    end

    it "should serialize the title for an rss2 feed" do
      @rss2.to_hash[:title].should == "Star City"
    end

    it "should serialize the item_id for an rss2 feed" do
      @rss2.to_hash[:item_id].should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
    end

    it "should serialize updated_at for an rss2 feed" do
      @rss2.to_hash[:updated_at].should == Time.utc(2003, 6, 3, 9, 39, 21)
    end

    it "should serialize the url for an rss2 feed" do
      @rss2.to_hash[:url].should == "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"
    end

    it "should serialize the author of an rss2 feed" do
      author = @rss2.to_hash[:author]

      author.name.should == "Chuck Norris"
      author.email.should == "da_man@example.com"
      author.uri.should be_nil
    end

    it "should serialize the title for an rss1 feed" do
      @rss1.to_hash[:title].should == "Processing Inclusions with XSLT"
    end

    it "should serialize the item_id for an rss1 feed" do
      @rss1.to_hash[:item_id].should == "http://xml.com/pub/2000/08/09/xslt/xslt.html"
    end

    it "should serialize updated_at for an rss1 feed" do
      @rss1.to_hash[:updated_at].should == Time.utc(2010, 6, 3, 10, 7, 42)
    end

    it "should serialize the url for an rss1 feed" do
      @rss1.to_hash[:url].should == "http://google.com/foobar"
    end

    it "should serialize the author of an rss1 feed" do
      author = @rss1.to_hash[:author]

      author.name.should == "akeri.se"
      author.email.should be_nil
      author.uri.should be_nil
    end

  end

end

describe "Without an author", FeedMe::ItemParser do

  before :each do
    @atom_feed = FeedMe::FeedParser.open(fixture('welformed.atom'))
    @atom = @atom_feed.entries[1]
    @rss2_feed = FeedMe::FeedParser.open(fixture('welformed.rss2'))
    @rss2 = @rss2_feed.entries[1]
    @rss1_feed = FeedMe::FeedParser.open(fixture('welformed.rss1'))
    @rss1 = @rss1_feed.entries[1]
  end

  describe '#author.name' do
    it "should be valid for an atom feed" do
      @atom.author.name.should be_nil
    end

    it "should be valid for an rss2 feed" do
      @rss2.author.name.should be_nil
    end

    it "should be valid for an rss1 feed" do
      @rss1.author.name.should be_nil
    end
  end

end
