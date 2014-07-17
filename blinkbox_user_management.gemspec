#coding: utf-8
lib = File.join(__dir__,'lib')
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name          = "blinkbox_user_management"
	spec.version       = ::File.read("VERSION")
	spec.authors       = ["blinkbox books"]
	spec.email         = ["alexjo@blinkbox.com"]
	spec.description   = %q{blinkbox ruby user management api}
	spec.summary       = %q{blinkbox ruby user management api}
	spec.homepage      = "https://git.mobcastdev.com/alexjo/blinkbox_user_management"
	spec.license       = "MIT"

	spec.files         = [*Dir["{lib,bin,spec}/**/*.rb"], "VERSION"]
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]

	spec.add_runtime_dependency "httparty"
	spec.add_runtime_dependency "multi_json"
end
