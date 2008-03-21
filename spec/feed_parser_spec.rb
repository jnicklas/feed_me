require File.join( File.dirname(__FILE__), "spec_helper" )

require 'feed_me'

describe "all parsing methods", :shared => true do
  it "should identify an atom feed" do
    @atom.should be_an_instance_of(FeedMe::AtomFeedParser)
    @atom.format.should == :atom
    @atom.root_node.xpath == "//feed[@xmlns='http://www.w3.org/2005/Atom']"
  end
  
  it "should identify an rss2 feed" do
    @rss2.should be_an_instance_of(FeedMe::Rss2FeedParser)
    @rss2.format.should == :rss2
    @rss2.root_node.xpath == "//rss[@version=2.0]/channel"
  end
end

describe FeedMe::FeedParser do

  before :each do
    @atom_feed = hpricot_fixture('welformed.atom') / "//feed[@xmlns='http://www.w3.org/2005/Atom']"
    @atom = FeedMe::FeedParser.build(@atom_feed, :atom)
    @rss2_feed = hpricot_fixture('welformed.rss2') / "//rss[@version=2.0]/channel"
    @rss2 = FeedMe::FeedParser.build(@rss2_feed, :rss2)
  end

  it "should be an atom parser for an atom feed" do
    @atom.should be_an_instance_of(FeedMe::AtomFeedParser)
  end

  describe ".parse" do
    before(:each) do
      @atom = FeedMe::FeedParser.parse(open(fixture('welformed.atom')).read)
      @rss2 = FeedMe::FeedParser.parse(open(fixture('welformed.rss2')).read)
    end
    
    it_should_behave_like "all parsing methods"
  end
  
  describe ".open" do
    before(:each) do
      @atom = FeedMe::FeedParser.open(fixture('welformed.atom'))
      @rss2 = FeedMe::FeedParser.open(fixture('welformed.rss2'))
    end
    
    it_should_behave_like "all parsing methods"
  end
    
  describe '#title' do
    it "should be valid for an atom feed" do
      @atom.title.should == "Test feed"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.title.should == "Lift Off News"
    end
  end
  
  describe '#description' do
    it "should be valid for an atom feed" do
      @atom.description.should == "Monkey test feed"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.description.should == "Liftoff to Space Exploration."
    end
  end
  
  describe '#feed_id' do
    it "should be valid for an atom feed" do
      @atom.feed_id.should == "tag:imaginary.host:nyheter"
    end
    
    it "should be nil for an rss2 feed" do
      @rss2.feed_id.should be_nil
    end
  end
  
  describe '#updated_at' do
    it "should be valid for an atom feed" do
      @atom.updated_at.should == "2008-03-07T20:41:10Z"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.updated_at.should == "Tue, 10 Jun 2003 09:41:01 GMT"
    end
  end
  
  describe '#href' do
    it "should be valid for an atom feed" do
      @atom.href.should == "http://imaginary.host/posts.atom"
    end
    
    it "should be nil for an atom feed" do
      @rss2.href.should be_nil
    end
  end
  
  describe '#url' do
    it "should be valid for an atom feed" do
      @atom.url.should == "http://imaginary.host/posts"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.url.should == "http://liftoff.msfc.nasa.gov/"
    end
  end
  
  describe '#generator' do
    it "should be valid for an atom feed" do
      @atom.generator.should == "Roll your own"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.generator.should == "Weblog Editor 2.0"
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
  
  describe '#author.name' do
    it "should be valid for an atom feed" do
      @atom.author.name.should == "Frank"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.author.name.should == "Mary Jo"
    end
  end
  
  describe '#author.email' do
    it "should be valid for an atom feed" do
      @atom.author.email.should == "frank@imaginary.host"
    end
    
    it "should be valid for an rss2 feed" do
      @rss2.author.email.should == "editor@example.com"
    end
  end

end