# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'image/resizer/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'image-resizer-rails'
  spec.version       = Image::Resizer::Rails::VERSION
  spec.authors       = ['James Nicol']
  spec.email         = ['james.andrew.nicol@gmail.com']
  spec.description   = %q{Helpers for use with image-resizer service}
  spec.homepage      = 'https://github.com/jimmynicol/image-resizer-rails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'railties', '>= 3.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'awesome_print'

end