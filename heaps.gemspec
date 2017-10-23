# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heaps/version'

Gem::Specification.new do |spec|
  spec.name          = "heaps"
  spec.version       = Heaps::VERSION
  spec.authors       = ["James Scott"]
  spec.email         = ["skoona@gmail.com"]

  spec.summary       = %q{Minimal Heap pattern.}
  spec.description   = %q{A min-heap is a binary tree data structure in which the data of each node is less than or equal to the data of that node’s children and the tree is complete.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "pry", "~> 0.11"
end
