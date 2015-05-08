# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'makemespiffy/version'

Gem::Specification.new do |spec|
  spec.name          = "makemespiffy"
  spec.version       = MakeMeSpiffy::VERSION
  spec.authors       = ["Dr Nic Williams"]
  spec.email         = ["drnicwilliams@gmail.com"]
  spec.summary       = %q{Convert a flat BOSH manifest for something into a set of Spiff templates.}
  spec.description   = %q{Convert a flat BOSH manifest for something into a set of Spiff templates.}
  spec.homepage      = "https://github.com/cloudfoundry-community/makemespiffy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
