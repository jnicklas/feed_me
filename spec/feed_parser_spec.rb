require File.join( File.dirname(__FILE__), "spec_helper" )

require 'feed_me'

describe "all parsing methods", :shared => true do
  it "should identify an atom feed" do
    @atom.should be_an_instance_of(FeedMe::AtomFeedParser)
    @atom.root_node.xpath == "//feed[@xmlns='http://www.w3.org/2005/Atom']"
  end

  it "should identify an rss2 feed" do
    @rss2.should be_an_instance_of(FeedMe::Rss2FeedParser)
    @rss2.root_node.xpath == "//rss[@version=2.0]/channel"
  end

  describe "with bad input" do
    it "should raise on an empty body" do
      lambda { FeedMe::FeedParser.parse("") }.should raise_error(FeedMe::InvalidFeedFormat)
    end

    it "should raise on a body with non-recognised xml" do
      lambda {
        FeedMe::FeedParser.parse(%Q|<?xml version="1.0" encoding="UTF-8"?>"<foo>bar</foo>|)
      }.should raise_error(FeedMe::InvalidFeedFormat)
    end
  end
end

describe FeedMe::FeedParser do

  before :each do
    @atom = FeedMe::FeedParser.parse(open(fixture('welformed.atom')).read)
    @rss2 = FeedMe::FeedParser.parse(open(fixture('welformed.rss2')).read)
    @rss1 = FeedMe::FeedParser.parse(open(fixture('welformed.rss1')).read)
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

    it "should be valid for an rss1 feed" do
      @rss1.title.should == "XML.com"
    end
  end

  describe '#description' do
    it "should be valid for an atom feed" do
      @atom.description.should == "Monkey test feed"
    end

    it "should be valid for an rss2 feed" do
      @rss2.description.should == "Liftoff to Space Exploration."
    end

    it "should be valid for an rss1 feed" do
      @rss1.description.should == "XML.com features a rich mix of information and services"
    end
  end

  describe '#feed_id' do
    it "should be valid for an atom feed" do
      @atom.feed_id.should == "tag:imaginary.host:nyheter"
    end

    it "should be nil for an rss2 feed" do
      @rss2.feed_id.should be_nil
    end

    it "should be nil for an rss1 feed" do
      @rss1.feed_id.should be_nil
    end
  end

  describe '#updated_at' do
    it "should be valid for an atom feed" do
      @atom.updated_at.should == Time.utc(2008, 3, 7, 20, 41, 10)
    end

    it "should be valid for an rss2 feed" do
      @rss2.updated_at.should == Time.utc(2003, 6, 10, 9, 41, 1)
    end

    it "should be taken from dublin core time for an rss1 feed" do
      @rss1.updated_at.should == Time.utc(2010, 6, 3, 14, 56, 42)
    end
  end

  describe '#href' do
    it "should be valid for an atom feed" do
      @atom.href.should == "http://imaginary.host/posts.atom"
    end

    it "should be nil for an rss2 feed" do
      @rss2.href.should be_nil
    end

    it "should be valid for an rss1 feed" do
      @rss1.href.should == "http://www.xml.com/xml/news.rss"
    end
  end

  describe '#url' do
    it "should be valid for an atom feed" do
      @atom.url.should == "http://imaginary.host/posts"
    end

    it "should be valid for an rss2 feed" do
      @rss2.url.should == "http://liftoff.msfc.nasa.gov/"
    end

    it "should be valid for an rss1 feed" do
      @rss1.url.should == "http://xml.com/pub"
    end
  end

  describe '#generator' do
    it "should be valid for an atom feed" do
      @atom.generator.should == "Roll your own"
    end

    it "should be valid for an rss2 feed" do
      @rss2.generator.should == "Weblog Editor 2.0"
    end

    it "should be nil for an rss1 feed" do
      @rss1.generator.should be_nil
    end
  end

  describe '#author.name' do
    it "should be valid for an atom feed" do
      @atom.author.name.should == "Frank"
    end

    it "should be valid for an rss2 feed" do
      @rss2.author.name.should == "Mary Jo"
    end

    it "should be taken from dublin core for an rss1 feed" do
      @rss1.author.name.should == "Foopaq (mailto:support@foopaq.se)"
    end
  end

  describe '#author.email' do
    it "should be valid for an atom feed" do
      @atom.author.email.should == "frank@imaginary.host"
    end

    it "should be valid for an rss2 feed" do
      @rss2.author.email.should == "editor@example.com"
    end

    it "should be nil for an rss1 feed" do
      @rss1.author.email.should be_nil
    end
  end

  describe '#author.uri' do
    it "should be valid for an atom feed" do
      @atom.author.uri.should == "http://imaginary.host/students/frank"
    end

    it "should be nil for an rss2 feed" do
      @rss2.author.uri.should be_nil
    end

    it "should be nil for an rss1 feed" do
      @rss1.author.uri.should be_nil
    end
  end

  describe '#entries' do
    it "should return an array of entries for an atom feed" do
      @atom.entries.should be_an_instance_of(Array)
    end

    it "should have the correct length for an atom feed" do
      @atom.should have(3).entries
    end

    it "should return items that are properly parsed for an atom feed" do
      @atom.entries.first.title.should == "First title"
      @atom.entries.first.url.should == "http://imaginary.host/posts/3"
    end

    it "should return an array of entries for an rss2 feed" do
      @rss2.entries.should be_an_instance_of(Array)
    end

    it "should have the correct length for an rss2 feed" do
      @rss2.should have(4).entries
    end

    it "should return items that are properly parsed for an rss2 feed" do
      @rss2.entries.first.title.should == "Star City"
      @rss2.entries.first.url.should == "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"
      @rss2.entries.first.item_id.should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
    end

    it "should return an array of entries for an rss1 feed" do
      @rss1.entries.should be_an_instance_of(Array)
    end

    it "should have the correct length for an rss1 feed" do
      @rss1.should have(3).entries
    end

    it "should return items that are properly parsed for an rss1 feed" do
      @rss1.entries.first.title.should == "Processing Inclusions with XSLT"
      @rss1.entries.first.url.should == "http://google.com/foobar"
      @rss1.entries.first.item_id.should == "http://xml.com/pub/2000/08/09/xslt/xslt.html"
    end

    it "should allow items to be read more than once" do
      item = @rss2.entries.first
      item.item_id.should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
      item.item_id.should == "http://liftoff.msfc.nasa.gov/2003/06/03.html#item573"
    end
  end

  describe '#to_hash' do
    it "should serialize the title of an atom feed" do
      @atom.to_hash[:title].should == "Test feed"
    end

    it "should serialize the description of an atom feed" do
      @atom.to_hash[:description].should == "Monkey test feed"
    end

    it "should serialize the feed_id of an atom feed" do
      @atom.to_hash[:feed_id].should == "tag:imaginary.host:nyheter"
    end

    it "should serialize the updated_at time of an atom feed" do
      @atom.to_hash[:updated_at].should == Time.utc(2008, 3, 7, 20, 41, 10)
    end

    it "should serialize the href of an atom feed" do
      @atom.to_hash[:href].should == "http://imaginary.host/posts.atom"
    end

    it "should serialize the url of an atom feed" do
      @atom.to_hash[:url].should == "http://imaginary.host/posts"
    end

    it "should serialize the generator of an atom feed" do
      @atom.to_hash[:generator].should == "Roll your own"
    end

    it "should serialize the entries of an atom feed" do
      @atom.to_hash[:entries].should be_an_instance_of(Array)
      @atom.to_hash[:entries].first.title.should == "First title"
      @atom.to_hash[:entries].first.url.should == "http://imaginary.host/posts/3"
    end

    it "should serialize the author of an atom feed" do
      author = @atom.to_hash[:author]

      author.name.should == "Frank"
      author.email.should == "frank@imaginary.host"
      author.uri.should == "http://imaginary.host/students/frank"
    end

    it "should serialize the title of an rss2 feed" do
      @rss2.to_hash[:title].should == "Lift Off News"
    end

    it "should serialize the description of an rss2 feed" do
      @rss2.to_hash[:description].should == "Liftoff to Space Exploration."
    end

    it "should serialize the feed_id of an rss2 feed" do
      @rss2.to_hash[:feed_id].should be_nil
    end

    it "should serialize the updated_at time of an rss2 feed" do
      @rss2.to_hash[:updated_at].should == Time.utc(2003, 6, 10, 9, 41, 1)
    end

    it "should serialize the href of an rss2 feed" do
      @rss2.to_hash[:href].should be_nil
    end

    it "should serialize the url of an rss2 feed" do
      @rss2.to_hash[:url].should == "http://liftoff.msfc.nasa.gov/"
    end

    it "should serialize the generator of an rss2 feed" do
      @rss2.to_hash[:generator].should == "Weblog Editor 2.0"
    end

    it "should serialize the entries of an rss2 feed" do
      @rss2.to_hash[:entries].should be_an_instance_of(Array)
      @rss2.to_hash[:entries].first.title.should == "Star City"
      @rss2.to_hash[:entries].first.url.should == "http://liftoff.msfc.nasa.gov/news/2003/news-starcity.asp"
    end

    it "should serialize the author of an rss2 feed" do

      author = @rss2.to_hash[:author]

      author.name.should == "Mary Jo"
      author.email.should == "editor@example.com"
      author.uri.should be_nil
    end

    it "should serialize the title of an rss1 feed" do
      @rss1.to_hash[:title].should == "XML.com"
    end

    it "should serialize the description of an rss1 feed" do
      @rss1.to_hash[:description].should == "XML.com features a rich mix of information and services"
    end

    it "should serialize the feed_id of an rss1 feed" do
      @rss1.to_hash[:feed_id].should be_nil
    end

    it "should serialize the updated_at time of an rss1 feed" do
      @rss1.to_hash[:updated_at].should == Time.utc(2010, 6, 3, 14, 56, 42)
    end

    it "should serialize the href of an rss1 feed" do
      @rss1.to_hash[:href].should == "http://www.xml.com/xml/news.rss"
    end

    it "should serialize the url of an rss1 feed" do
      @rss1.to_hash[:url].should == "http://xml.com/pub"
    end

    it "should serialize the generator of an rss1 feed" do
      @rss1.to_hash[:generator].should be_nil
    end

    it "should serialize the entries of an rss1 feed" do
      @rss1.to_hash[:entries].should be_an_instance_of(Array)
      @rss1.to_hash[:entries].first.title.should == "Processing Inclusions with XSLT"
      @rss1.to_hash[:entries].first.url.should == "http://google.com/foobar"
    end

    it "should serialize the author of an rss1 feed" do

      author = @rss1.to_hash[:author]

      author.name.should == "Foopaq (mailto:support@foopaq.se)"
      author.email.should be_nil
      author.uri.should be_nil
    end
  end

end
