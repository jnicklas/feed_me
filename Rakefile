require 'rubygems'
require 'rake/gempackagetask'
require 'spec/rake/spectask'

file_list = FileList['spec/*_spec.rb']

namespace :spec do
  desc "Run all examples with RCov"
  Spec::Rake::SpecTask.new('rcov') do |t|
    t.spec_files = file_list
    t.rcov = true
    t.rcov_dir = "doc/coverage"
    t.rcov_opts = ['--exclude', 'spec']
  end
  
  desc "Generate an html report"
  Spec::Rake::SpecTask.new('report') do |t|
    t.spec_files = file_list
    t.rcov_opts = ['--exclude', 'spec']
    t.spec_opts = ["--format", "html:doc/reports/specs.html"]
    t.fail_on_error = false
  end

end

desc 'Default: run specs.'
task :default => 'spec:rcov'

PLUGIN = "feed_me"
NAME = "feed_me"
VERSION = "0.0.2"
AUTHOR = ["Jonas Nicklas", "Jonathan Stott"]
EMAIL = "jonas.nicklas@gmail.com"
HOMEPAGE = "http://github.com/jnicklas/feed_me"
SUMMARY = "Nice and simple RSS and atom feed parsing built on hpricot"

spec = Gem::Specification.new do |s|
  s.name = NAME
  s.platform = Gem::Platform::RUBY
  s.version = VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.authors = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.require_path = 'lib'
  s.autorequire = PLUGIN
  s.add_dependency('hpricot')
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs}/**/*")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new(spec)
rescue
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install namelessjon-jeweler -s http://gems.github.com"
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{NAME}-#{VERSION}}
end

namespace :jruby do

  desc "Run :package and install the resulting .gem with jruby"
  task :install => :package do
    sh %{#{SUDO} jruby -S gem install pkg/#{NAME}-#{Merb::VERSION}.gem --no-rdoc --no-ri}
  end
  
end
