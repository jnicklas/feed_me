require File.join( File.dirname(__FILE__), "spec_helper" )

require 'feed_me'

describe FeedMe::ItemParser do

  before :each do
    @atom_feed = FeedMe::FeedParser.open(fixture('welformed.atom'))
    @atom = FeedMe::AuthorParser.new(@atom_feed.root_node.search('/entry/author').first, :atom)
  end
    
  describe '#email' do
    it "should be valid" do
      @atom.email.should == "jonas.nicklas@imaginary.host"
    end
  end
  
  describe '#name' do
    it "should be valid" do
      @atom.name.should == "Jonas Nicklas"
    end
  end
  
  describe '#uri' do
    it "should be valid" do
      @atom.uri.should == "http://imaginary.host/students/jnicklas"
    end
  end
  
end