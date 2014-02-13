# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'liquid_constant_contact/version'

Gem::Specification.new do |spec|
  spec.name          = "liquid_constant_contact"
  spec.version       = LiquidConstantContact::VERSION
  spec.authors       = ["Exodus Integrity Services, Inc.", "Marc Reynolds"]
  spec.email         = ["marc@exodus.com.my"]
  spec.description   = %q{ ConstantContact integration for Liquid}
  spec.summary       = %q{ Allows information from the ConstantContact API to be output on a site running Liquid.}
  spec.homepage      = "http://github.com/mrr728/liquid_constant_contact"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'activesupport', '~> 3'
  spec.add_development_dependency 'pry_debug'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'factory_girl'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-debugger'
  spec.add_development_dependency 'hammertime19'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'fakeredis'
  spec.add_dependency 'locomotivecms-solid', '~> 0.2.2.1'  
end
