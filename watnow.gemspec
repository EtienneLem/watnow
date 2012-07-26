# -*- encoding: utf-8 -*-
require File.expand_path('../lib/watnow/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Etienne Lemay"]
  gem.email         = ["etienne@heliom.ca"]
  gem.homepage      = "http://github.com/etiennelem/watnow"

  gem.description   = "watnow finds and lists your project TODOs and FIXMEs in your terminal"
  gem.summary       = gem.description
  gem.version       = Watnow::VERSION

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "watnow"
  gem.require_paths = ["lib"]
end
