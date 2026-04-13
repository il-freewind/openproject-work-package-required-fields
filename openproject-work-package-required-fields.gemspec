require_relative "lib/open_project/work_package_required_fields/version"

Gem::Specification.new do |spec|
  spec.name        = "openproject-work-package-required-fields"
  spec.version     = OpenProject::WorkPackageRequiredFields::VERSION
  spec.authors     = ["Codex"]
  spec.email       = ["dev@example.com"]
  spec.summary     = "OpenProject plugin scaffold for required work package field rules"
  spec.description = "Standalone OpenProject plugin that provides a foundation for conditional required fields in work packages."
  spec.homepage    = "https://www.openproject.org/"
  spec.license     = "GPL-3.0-or-later"

  spec.files = Dir[
    "{app,config,db,lib}/**/*",
    "Gemfile",
    "README.md",
    "openproject-work-package-required-fields.gemspec"
  ]

  spec.require_paths = ["lib"]

  spec.add_dependency "openproject-plugins", ">= 16.0", "< 18.0"
end
