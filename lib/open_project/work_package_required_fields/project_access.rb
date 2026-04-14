module OpenProject
  module WorkPackageRequiredFields
    module ProjectAccess
      module_function

      PROJECT_ADMIN_PERMISSIONS = %i[
        edit_project
        manage_work_package_required_fields
      ].freeze

      def allowed?(user, project)
        return false unless user && project
        return true if user.admin?

        PROJECT_ADMIN_PERMISSIONS.any? do |permission|
          user.allowed_in_project?(permission, project)
        rescue StandardError
          false
        end
      end
    end
  end
end
