# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cylon_arena/version"

Gem::Specification.new do |s|
  s.name        = "cylon_arena"
  s.version     = CylonArena::VERSION
  s.authors     = ["Jason Jones"]
  s.email       = ["jasonedwardjones@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Sweet robot combat action}
  s.description = %q{Sweet robot combat action}

  s.rubyforge_project = "cylon_arena"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
   s.add_runtime_dependency "gosu"
end
