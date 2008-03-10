require File.join( File.dirname(__FILE__), "spec_helper" )

require 'feed_me'

describe FeedMe::ItemParser do

  before :each do
    @atom_feed = FeedMe::FeedParser.open(fixture('welformed.atom'))
    @atom = FeedMe::ItemParser.new(@atom_feed.root_node.search('/entry').first, :atom)
    @rss2_feed = FeedMe::FeedParser.open(fixture('welformed.rss2'))
    @rss2 = FeedMe::ItemParser.new(@rss2_feed.root_node.search('/item').first, :rss2)
  end
    
  describe '#title' do
    it "should be valid for an atom feed" do
      @atom.title.should == "First title"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.title.should == "Star City"
    end
  end
  
  describe '#item_id' do
    it "should be valid for an atom feed" do
      @atom.item_id.should == "tag:imaginary.host,2008-03-07:nyheter/3"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.item_id.should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
    end
  end
  
  describe '#updated_at' do
    it "should be valid for an atom feed" do
      @atom.updated_at.should == "2008-03-07T20:41:10Z"
    end
    
    it "should be nil for an rss2 feed" do
      @rss2.updated_at.should be_nil
    end
  end
  
  describe '#url' do
    it "should be valid for an atom feed" do
      @atom.url.should == "http://imaginary.host/posts/3"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.url.should == "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"
    end
  end
  
  describe '#format' do
    it "should be :atom for an atom feed" do
      @atom.format.should == :atom
    end
    
    it "should be :rss2 for an rss2 feed" do
      @rss2.format.should == :rss2
    end
  end



end