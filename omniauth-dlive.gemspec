# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/dlive/version'

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-dlive'
  spec.version       = OmniAuth::Dlive::VERSION
  spec.authors       = ['Eugene Key']
  spec.email         = ['evgeny.konyaev@gmail.com']
  spec.summary       = 'Dlive OAuth2 Strategy for OmniAuth'
  spec.homepage      = 'https://github.com/EugeneKey/omniauth-dlive'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'omniauth-oauth2', '~> 1.6'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 13'
end
