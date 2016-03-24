# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fotofetch/version'

Gem::Specification.new do |spec|
  spec.name          = "fotofetch"
  spec.version       = Fotofetch::VERSION
  spec.authors       = ["Steven Olson"]
  spec.email         = ["steveoscaro@gmail.com"]

  spec.summary       = %q{Fotofetch searches for and brings in images.}
  spec.description   = %q{Fotofetch searches for and brings in images. Fotofetch searches for and brings in images. Fotofetch searches for and brings in images.}
  spec.homepage      = "https://github.com/SteveOscar/fotofetch"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = https://rubygems.org
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = Dir["**/*"].select { |f| File.file? f }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "mechanize"
  spec.add_runtime_dependency "fastimage"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "byebug"
end
