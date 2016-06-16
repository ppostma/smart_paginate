# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smart_paginate/version'

Gem::Specification.new do |spec|
  spec.name          = "smart_paginate"
  spec.version       = SmartPaginate::VERSION
  spec.authors       = ["Peter Postma"]
  spec.email         = ["peter.postma@gmail.com"]

  spec.summary       = "Simple, smart and clean pagination extension"
  spec.description   = "Simple, smart and clean pagination extension for Active Record and plain Ruby Arrays."
  spec.homepage      = "https://github.com/ppostma/smart_paginate"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4.0", ">= 3.4.0"
  spec.add_development_dependency "sqlite3", "~> 1.3", ">= 1.3.11"

  spec.add_dependency "activerecord", ">= 4.0.0", "< 4.3"
end
