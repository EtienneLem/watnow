# -*- encoding: utf-8 -*-
require File.expand_path('../lib/watnow/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Etienne Lemay"]
  gem.email         = ["etienne@heliom.ca"]
  gem.homepage      = "https://github.com/etiennelem/watnow"

  gem.description   = "Watnow finds and lists your project todo and fixme"
  gem.summary       = gem.description
  gem.version       = Watnow::VERSION

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "watnow"
  gem.require_paths = ["lib"]

  gem.add_dependency("colored", "~> 1.2")
end
