# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redmine_cli/version'

Gem::Specification.new do |spec|
  spec.name          = 'redmine_cli'
  spec.version       = RedmineCLI::VERSION
  spec.authors       = ['Dmitriy Non']
  spec.email         = ['non.dmitriy@gmail.com']

  spec.summary       = 'CLI for Redmine'
  spec.homepage      = 'https://github.com/Nondv/redmine_cli'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.1.1'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.36.0'

  spec.add_dependency 'thor', '~> 0.19'
  spec.add_dependency 'i18n', '~> 0.7'
  spec.add_dependency 'redmine_rest', '0.7.0'
  spec.add_dependency 'non_config', '0.1.2'
  spec.add_dependency 'colorize', '~> 0.7'
  spec.add_dependency 'unicode', '~> 0.4'
end
