<<<<<<< HEAD:lib/feed_me.rb
# make sure we're running inside Merb
if defined?(Merb::Plugins)
  dependency 'hpricot'
else
  require 'rubygems'
  require 'hpricot'
end
=======
require 'hpricot'
>>>>>>> No longer failing Time parsing specs:lib/feed_me.rb
require 'time'

module FeedMe
  class InvalidFeedFormat < StandardError ; end

  def self.parse(feed)
    FeedMe::FeedParser.parse(feed)
  end

  def self.open(file)
    FeedMe::FeedParser.parse(file)
  end
end

require 'feed_me/abstract_parser'
require 'feed_me/feed_parser'
require 'feed_me/item_parser'
require 'feed_me/person_parser'