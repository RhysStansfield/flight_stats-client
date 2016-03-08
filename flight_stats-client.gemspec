# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flight_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "flight_stats-client"
  spec.version       = FlightStats::VERSION
  spec.authors       = ["Rhys Stansfield", "David Goring"]
  spec.email         = ["david@bluebaboondigital.com"]
  spec.summary       = %q{Simple ruby api wrapper for FlightStats}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency "activesupport", ">= 3.2"
  spec.add_runtime_dependency "httparty", '~> 0.10.0'
end
