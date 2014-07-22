#coding: utf-8
lib = File.join(__dir__,'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name          = "blinkbox-user"
	spec.version       = ::File.read("VERSION")
	spec.authors       = ["blinkbox books"]
	spec.email         = ["alexjo@blinkbox.com", "mustaqila@blinkbox.com"]
	spec.description   = %q{blinkbox ruby user management api}
	spec.summary       = %q{blinkbox ruby user management api}
	spec.homepage      = "https://git.mobcastdev.com/TEST/blinkbox-user"
	spec.license       = "MIT"

	spec.files         = [*Dir["{lib,bin,spec}/**/*.rb"], "VERSION"]
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_runtime_dependency "httparty"
	spec.add_runtime_dependency "multi_json"
	
	spec.add_development_dependency "rspec", "~> 2.0"
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake", "~> 10.1"
	
end
