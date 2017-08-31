# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sunomono/version'

Gem::Specification.new do |spec|
  spec.name          = 'sunomono'
  spec.version       = Sunomono::VERSION
  spec.authors       = ['Oscar Tanner', 'Wellington Avelino']
  spec.email         = ['oscarpanda@gmail.com', 'wellington.santos@concrete.com.br']
  spec.summary       = 'Generates an android and iOS calabash project.'
  spec.description   = %q{A simple gem to generate all files needed in a project that will support Calabash for both Android and iOS.}
  spec.homepage      = 'https://github.com/concretesolutions/sunomono'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['sunomono', 'suno']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'bundler', '>= 1.7'
  spec.add_runtime_dependency 'rake', '>= 10.0'
  spec.add_runtime_dependency 'thor', '>= 0.19.1'
  spec.add_runtime_dependency 'i18n', '>= 0.6.11'
  spec.add_runtime_dependency 'gherkin', '2.12.2'
  spec.add_runtime_dependency 'rubyzip', '~>1.1'
end
