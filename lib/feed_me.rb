require 'hpricot'
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