# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
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

  spec.metadata      = { 'rubygems_mfa_required' => 'true' }

  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*']
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_development_dependency "bundler", ">= 1.12"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.10.0"
  spec.add_development_dependency "rubocop", "~> 1.12.0"
  spec.add_development_dependency "rubocop-performance"
  spec.add_development_dependency "rubocop-rake"
  spec.add_development_dependency "rubocop-rspec"

  spec.add_dependency "activerecord", ">= 4.2.0"
end
