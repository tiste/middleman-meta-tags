# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'middleman-meta-tags/version'

Gem::Specification.new do |spec|
  spec.name          = 'middleman-meta-tags'
  spec.version       = Middleman::MetaTags::VERSION
  spec.authors       = ['Baptiste Lecocq']
  spec.email         = ['baptiste.lecocq@gmail.com']
  spec.summary       = %q{Meta tags for Middleman}
  spec.description   = %q{Easy integration of meta tags into your Middleman app}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
end
