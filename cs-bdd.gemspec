# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cs/bdd/version'

Gem::Specification.new do |spec|
  spec.name          = "cs-bdd"
  spec.version       = CS::BDD::VERSION
  spec.authors       = ["Oscar Tanner"]
  spec.email         = ["oscar.tanner@concretesolutions.com.br"]
  spec.summary       = %q{Generates an android and iOS calabash project.}
  spec.description   = %q{A simple gem to generate all the folder and files needed to create an android and iOS calabash project.}
  spec.homepage      = "https://github.com/CSOscarTanner/cs-bdd"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ["cs-bdd"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "thor", "~> 0.19.1"
  spec.add_development_dependency "i18n", "~> 0.6.11"
  spec.add_development_dependency "gherkin", "~> 2.12.2"
end