module OpenProject
  module WorkPackageRequiredFields
    module Patches
      module WorkPackageRequiredFieldsPatch
        def self.prepended(base)
          base.validate :validate_required_fields_for_target_status
        end

        private

        def validate_required_fields_for_target_status
          missing_fields = Validator.missing_field_labels(self)
          return if missing_fields.empty?

          errors.add(
            :status_id,
            I18n.t(
              "openproject_work_package_required_fields.errors.required_fields_missing",
              fields: missing_fields.join(", ")
            )
          )
        end
      end
    end
  end
end
