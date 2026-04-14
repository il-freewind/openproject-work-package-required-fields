module OpenProject
  module WorkPackageRequiredFields
    module Hooks
      module_function

      def apply!
        require_dependency "open_project/work_package_required_fields/layout_hooks"
        require_dependency "open_project/work_package_required_fields/patches/work_package_required_fields_patch"
        require_dependency "open_project/work_package_required_fields/patches/project_work_packages_header_component_patch"

        apply_work_package_patch!
        apply_project_work_packages_header_component_patch!
      end

      def apply_work_package_patch!
        return unless defined?(WorkPackage)

        patch = OpenProject::WorkPackageRequiredFields::Patches::WorkPackageRequiredFieldsPatch
        WorkPackage.prepend(patch) unless WorkPackage < patch
      end

      def apply_project_work_packages_header_component_patch!
        return unless defined?(Settings::ProjectWorkPackages::HeaderComponent)

        patch = OpenProject::WorkPackageRequiredFields::Patches::ProjectWorkPackagesHeaderComponentPatch
        component = Settings::ProjectWorkPackages::HeaderComponent
        component.prepend(patch) unless component < patch
      end
    end
  end
end
