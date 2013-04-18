# -*- encoding: utf-8 -*-
require File.expand_path('../lib/activerepo/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["New Alexandria"]
  gem.email         = ["zak@newalexandria.org"]
  gem.description   = %q{Git repos with all the trimmings}
  gem.summary       = %q{ActiveRepo manages the common tasks surrounding version control for rails apps and gems. It follows the git-flow style of master-dev-feature-hotfix branching.  }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "activerepo"
  gem.require_paths = ["lib"]
  gem.version       = Activerepo::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "grit"
  gem.add_development_dependency "octopi"
end
