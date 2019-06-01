# frozen_string_literal: true
name = "matching_bundle"
$LOAD_PATH << File.expand_path("lib", __dir__)
require "#{name.tr("-", "/")}/version"

Gem::Specification.new name, MatchingBundle::VERSION do |s|
  s.summary = "Find a matching bundler version for a Gemfile and use it"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib/ bin/ MIT-LICENSE`.split("\n")
  s.executables = ["matching_bundle"]
  s.license = "MIT"
  s.required_ruby_version = ">= 2.3.0"
end
