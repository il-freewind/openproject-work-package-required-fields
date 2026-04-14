require_relative "lib/open_project/work_package_required_fields/version"

Gem::Specification.new do |spec|
  spec.name        = "openproject-work-package-required-fields"
  spec.version     = OpenProject::WorkPackageRequiredFields::VERSION
  spec.authors     = ["Codex"]
  spec.email       = ["dev@example.com"]
  spec.summary     = "Conditional required field rules for OpenProject work packages"
  spec.description = "OpenProject plugin for configuring required work package fields per project, type, and target status."
  spec.homepage    = "https://www.openproject.org/"
  spec.license     = "GPL-3.0-or-later"

  spec.files = Dir[
    "app/controllers/**/*",
    "app/models/**/*",
    "app/views/**/*",
    "config/**/*",
    "db/**/*",
    "lib/**/*",
    "Gemfile",
    "README.md",
    "openproject-work-package-required-fields.gemspec"
  ]

  spec.require_paths = ["lib"]

end
