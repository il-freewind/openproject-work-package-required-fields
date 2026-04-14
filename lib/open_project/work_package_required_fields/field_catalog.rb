module OpenProject
  module WorkPackageRequiredFields
    module FieldCatalog
      module_function

      STANDARD_FIELDS = [
        { key: "standard:subject", attribute: :subject, label: "Subject" },
        { key: "standard:description", attribute: :description, label: "Description" },
        { key: "standard:assigned_to_id", attribute: :assigned_to_id, label: "Assignee" },
        { key: "standard:responsible_id", attribute: :responsible_id, label: "Accountable" },
        { key: "standard:priority_id", attribute: :priority_id, label: "Priority" },
        { key: "standard:start_date", attribute: :start_date, label: "Start date" },
        { key: "standard:due_date", attribute: :due_date, label: "Due date" },
        { key: "standard:estimated_hours", attribute: :estimated_hours, label: "Estimated time" },
        { key: "standard:remaining_hours", attribute: :remaining_hours, label: "Remaining time" },
        { key: "standard:fixed_version_id", attribute: :fixed_version_id, label: "Version" },
        { key: "standard:category_id", attribute: :category_id, label: "Category" },
        { key: "standard:parent_id", attribute: :parent_id, label: "Parent" },
        { key: "standard:done_ratio", attribute: :done_ratio, label: "Percent complete" }
      ].freeze

      def all_for(project:)
        standard_options + custom_field_options(project:)
      end

      def grouped_options(project:)
        {
          I18n.t("openproject_work_package_required_fields.fields.groups.standard") => standard_options.map { |field| [field[:label], field[:key]] },
          I18n.t("openproject_work_package_required_fields.fields.groups.custom") => custom_field_options(project:).map { |field| [field[:label], field[:key]] }
        }
      end

      def label_for(field_key, project:)
        field_definition(field_key, project:)&.fetch(:label, nil) || field_key
      end

      def valid_key?(field_key, project:)
        field_definition(field_key, project:).present?
      end

      def blank?(work_package, field_key)
        definition = field_definition(field_key, project: work_package.project)
        return true unless definition

        if definition[:custom_field]
          custom_field_blank?(work_package, definition[:custom_field])
        else
          value = work_package.public_send(definition[:attribute])
          blank_value?(value)
        end
      end

      def field_definition(field_key, project:)
        standard_options.find { |field| field[:key] == field_key } ||
          custom_field_options(project:).find { |field| field[:key] == field_key }
      end

      def standard_options
        STANDARD_FIELDS.map do |field|
          field.merge(label: translated_label(field))
        end
      end

      def custom_field_options(project:)
        available_custom_fields(project).map do |custom_field|
          {
            key: "custom:#{custom_field.id}",
            label: custom_field.name,
            custom_field:
          }
        end
      end

      def translated_label(field)
        attribute_name = field[:attribute].to_s.sub(/_id\z/, "")

        WorkPackage.human_attribute_name(attribute_name)
      rescue StandardError
        field[:label]
      end

      def available_custom_fields(project)
        return [] unless defined?(WorkPackageCustomField)

        if project.respond_to?(:all_work_package_custom_fields)
          project.all_work_package_custom_fields.to_a
        elsif WorkPackageCustomField.respond_to?(:visible)
          WorkPackageCustomField.visible.to_a
        else
          WorkPackageCustomField.all.to_a
        end
      end

      def custom_field_blank?(work_package, custom_field)
        value =
          if work_package.respond_to?(:custom_value_for)
            work_package.custom_value_for(custom_field)&.value
          elsif work_package.respond_to?(:custom_field_values)
            work_package.custom_field_values[custom_field.id]
          end

        blank_value?(value)
      end

      def blank_value?(value)
        if value.is_a?(Array)
          value.all? { |entry| entry.blank? }
        else
          value.blank?
        end
      end
    end
  end
end
