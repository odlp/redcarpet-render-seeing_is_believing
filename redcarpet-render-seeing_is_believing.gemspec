lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redcarpet/render/seeing_is_believing/version"

Gem::Specification.new do |spec|
  spec.name          = "redcarpet-render-seeing_is_believing"
  spec.version       = Redcarpet::Render::SeeingIsBelieving::VERSION
  spec.authors       = ["Oli Peate"]
  spec.license       = "MIT"

  spec.summary       = "Evaluates Ruby code in your markdown, for awesome examples."
  spec.homepage      = "https://github.com/odlp/redcarpet-render-seeing_is_believing"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features|example_app)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redcarpet"
  spec.add_dependency "seeing_is_believing"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "nokogiri", "~> 1.8"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rouge"
  spec.add_development_dependency "rspec", "~> 3.7"
  spec.add_development_dependency "sinatra", "~> 2.0"
end
