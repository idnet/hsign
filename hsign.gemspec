# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hsign/version'

Gem::Specification.new do |gem|
  gem.name          = "hsign"
  gem.version       = HSign::VERSION
  gem.authors       = ["Helios Technologies Ltd."]
  gem.email         = ["hery@heliostech.hk"]
  gem.description   = %q{Web Digital Signature}
  gem.summary       = %q{Web Digital Signature}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.add_dependency "rack"
  gem.add_development_dependency "test-unit"
  gem.add_development_dependency "rake"
  gem.require_paths = ["lib"]
end
