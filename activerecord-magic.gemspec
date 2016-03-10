# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/magic/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-magic"
  spec.version       = ActiveRecord::Magic::VERSION
  spec.authors       = ["gizmore"]
  spec.email         = ["gizmore@wechall.net"]

  spec.summary       = "Useful active record extensions and decorators"
  spec.description   = "Useful active record extensions and decorators like arm-cache, arm-enum, arm-performance"
  spec.homepage      = "https://github.com/gizmore/activerecord_magic"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "byebug", "~> 8.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"

  spec.add_runtime_dependency "filewalker", "~> 0.1"
  spec.add_runtime_dependency "mail", "~> 2.6"
  spec.add_runtime_dependency "activerecord", "~> 4.2"
  spec.add_runtime_dependency "mysql2", "~> 0.3"

end
