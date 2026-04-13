require "open_project/plugins"

module OpenProject
  module WorkPackageRequiredFields
    class Engine < ::Rails::Engine
      engine_name :openproject_work_package_required_fields

      include OpenProject::Plugins::ActsAsOpEngine

      register(
        "openproject-work-package-required-fields",
        author: "Codex",
        bundled: false,
        settings: {
          default: {},
          partial: nil
        }
      ) do
        name "Work package required fields"
        description "Conditional required field rules for OpenProject work packages"
        version OpenProject::WorkPackageRequiredFields::VERSION
      end

      initializer "openproject_work_package_required_fields.load_hook" do
        ActiveSupport::Reloader.to_prepare do
          require_dependency "open_project/work_package_required_fields/hooks"
          OpenProject::WorkPackageRequiredFields::Hooks.apply!
        end
      end
    end
  end
end
