# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rendering_engine/version'

Gem::Specification.new do |spec|
  spec.name          = 'rendering_engine'
  spec.version       = RenderingEngine::VERSION
  spec.authors       = ['Paweł Niemczyk']
  spec.email         = ['pniemczyk@o2.pl']
  spec.description   = %q{ Rendering engine based on ERB }
  spec.summary       = %q{ Rendering engine based on ERB }
  spec.homepage      = 'https://github.com/pniemczyk/rendering_engine'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'guard-rspec', '~> 0'
  spec.add_development_dependency 'coveralls', '~> 0'
end
