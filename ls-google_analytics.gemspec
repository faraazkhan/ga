# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ls/google_analytics/version'

Gem::Specification.new do |spec|
  spec.name          = "ls-google_analytics"
  spec.version       = LS::GoogleAnalytics::VERSION
  spec.authors       = ["Faraaz Khan"]
  spec.email         = ["faraaz.khan@hungrymachine.com"]
  spec.summary       = %q{Simple Helpers for Universal Analytics}
  spec.description   = %q{Simple Helpers for Universal Analytics}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
