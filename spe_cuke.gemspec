# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'spe_cuke/version'

Gem::Specification.new do |s|
  s.name        = "spe_cuke"
  s.version     = SpeCuke::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["MOROHASHI Kyosuke"]
  s.email       = ["moronatural@gmail.com"]
  s.homepage    = "http://rubygems.org/gems/spe_cuke"
  s.summary     = "Provides common interface for rake spec or bin/spec."
  s.description = "An abstraction command for testing frameworks and invokation methods of them."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "spe_cuke"

  s.add_development_dependency "bundler", ">= 1.0.0.rc.5"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}.map{|bin| File.basename(bin) }
  s.require_path = 'lib'
end
