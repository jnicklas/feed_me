# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{feed_me}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jonas Nicklas", "Jonathan Stott"]
  s.autorequire = %q{feed_me}
  s.date = %q{2009-03-21}
  s.description = %q{Nice and simple RSS and atom feed parsing built on hpricot}
  s.email = %q{jonas.nicklas@gmail.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/feed_me", "lib/feed_me/consts.rb", "lib/feed_me/feed_struct.rb", "lib/feed_me/item_parser.rb", "lib/feed_me/merbtasks.rb", "lib/feed_me/simple_struct.rb", "lib/feed_me/abstract_parser.rb", "lib/feed_me/feed_parser.rb", "lib/feed_me.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/jnicklas/feed_me}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Nice and simple RSS and atom feed parsing built on hpricot}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hpricot>, [">= 0"])
    else
      s.add_dependency(%q<hpricot>, [">= 0"])
    end
  else
    s.add_dependency(%q<hpricot>, [">= 0"])
  end
end
