module FeedMe
  
  class AtomAuthorParser < AbstractParser
  
    property :email, 'author/email'
    property :name, 'author/name'
    property :uri, 'author/uri'
  
  end

end