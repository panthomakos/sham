# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sham/version"

Gem::Specification.new do |s|
  s.name        = "sham"
  s.version     = Sham::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pan Thomakos"]
  s.email       = ["pan.thomakos@gmail.com"]
  s.homepage    = "http://github.com/panthomakos/sham"
  s.summary     = "sham-#{Sham::VERSION}"
  s.description = %q{Lightweight flexible factories for Ruby on Rails testing.}

  s.rubyforge_project = "sham"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["README.markdown", "License.txt"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
end
