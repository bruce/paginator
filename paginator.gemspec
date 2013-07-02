# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'paginator/version'

Gem::Specification.new do |spec|
  spec.name          = "paginator"
  spec.version       = Paginator::VERSION
  spec.authors       = ["Bruce Williams"]
  spec.email         = ["bruce.williams@livingsocial.com"]
  spec.summary       = 'A generic paginator object for use in any Ruby program'
  spec.description   = "Paginator doesn't make any assumptions as to how data is retrieved; you just have to provide it with tee total number of objects and a way to pull a specific set of objects based on the offset and number of objects per page."
  spec.homepage      = "http://github.com/bruce/paginator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
end
