# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku_addon_provider/version'

Gem::Specification.new do |gem|
  gem.name          = "heroku_addon_provider"
  gem.version       = HerokuAddonProvider::VERSION
  gem.authors       = ["Stefan Natchev", "Adam Duke"]
  gem.email         = ["stefan.natchev@gmail.com", "adam.v.duke@gmail.com"]
  gem.summary       = %q{A gem for abstracting common addon provider concerns}
  gem.description   = %q{A gem for abstracting common heroku addon provider concerns}
  gem.homepage      = "https://github.com/SymmetricInfinity/heroku_addon_provider"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.required_ruby_version = '>= 1.9'

  gem.add_runtime_dependency 'faraday', '~> 0.8', '>= 0.8.5'
  gem.add_runtime_dependency 'faraday_middleware', '~> 0.9', '>= 0.9.0'

  gem.add_development_dependency 'minitest', '~> 4.7', '>= 4.7.0'
  gem.add_development_dependency 'rake', '~> 10.0', '>= 10.0.3'
end
