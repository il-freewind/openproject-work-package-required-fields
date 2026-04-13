module OpenProject
  module WorkPackageRequiredFields
    module Hooks
      module_function

      def apply!
        require_dependency "open_project/work_package_required_fields/patches/work_package_required_fields_patch"

        return unless defined?(WorkPackage)

        WorkPackage.prepend(OpenProject::WorkPackageRequiredFields::Patches::WorkPackageRequiredFieldsPatch) unless
          WorkPackage < OpenProject::WorkPackageRequiredFields::Patches::WorkPackageRequiredFieldsPatch
      end
    end
  end
end
