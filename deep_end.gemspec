# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deep_end/version'

Gem::Specification.new do |gem|
  gem.name          = "deep_end"
  gem.version       = DeepEnd::VERSION
  gem.authors       = ["Pedr Browne"]
  gem.email         = ["pedr.browne@gmail.com"]
  gem.description   = %q{Simple dependency resolver}
  gem.summary       = %q{This gem processes a list of objects and their dependencies, ordering them in such a way that dependencies are correctly resolved. It checks for circular dependencies and self-dependencies.}
  gem.homepage      = "https://github.com/stationkeeping/Deep-End"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rake', '~> 10.1')
  gem.add_development_dependency('rspec', '~> 2.14')
end
