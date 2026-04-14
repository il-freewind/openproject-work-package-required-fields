module OpenProject
  module WorkPackageRequiredFields
    module Patches
      module ProjectWorkPackagesHeaderComponentPatch
        def tabs
          existing_tabs = super
          return existing_tabs unless required_fields_tab_visible?

          existing_tabs + [
            {
              name: "required_fields",
              path: project_settings_work_packages_required_fields_path(@project),
              label: I18n.t("openproject_work_package_required_fields.project.title")
            }
          ]
        end

        private

        def required_fields_tab_visible?
          EnabledProject.enabled?(@project) &&
            ProjectAccess.allowed?(User.current, @project)
        end
      end
    end
  end
end
