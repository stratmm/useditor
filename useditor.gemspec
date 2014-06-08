# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'useditor/version'

Gem::Specification.new do |spec|
  spec.name          = "useditor"
  spec.version       = Useditor::VERSION
  spec.authors       = ["stratmm"]
  spec.email         = ["mark@stratmann.me.uk"]
  spec.description   = %q{The USEditor project.}
  spec.summary       = %q{The USEditor project.}
  spec.homepage      = "http://github.com/stratmm/useditor"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "colored"
  spec.add_dependency "terminal-table"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "fakefs"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-debugger'
end
