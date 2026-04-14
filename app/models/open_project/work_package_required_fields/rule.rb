module OpenProject
  module WorkPackageRequiredFields
    class Rule < ::ApplicationRecord
      self.table_name = "op_wp_required_fields_rules"

      FIELD_PREFIX_STANDARD = "standard".freeze
      FIELD_PREFIX_CUSTOM = "custom".freeze

      belongs_to :project
      belongs_to :type
      belongs_to :status

      validates :project_id, :type_id, :status_id, :field_key, presence: true
      validates :field_key, uniqueness: { scope: %i[project_id type_id status_id] }
      validate :field_key_must_exist_for_project

      scope :ordered, -> { order(:type_id, :status_id, :field_key) }
      scope :for_work_package, lambda { |work_package|
        where(
          project_id: work_package.project_id,
          type_id: work_package.type_id,
          status_id: work_package.status_id
        )
      }

      def self.replace_for_project!(project, rows)
        transaction do
          where(project_id: project.id).delete_all

          rows.each do |row|
            create!(
              project_id: project.id,
              type_id: row.fetch(:type_id),
              status_id: row.fetch(:status_id),
              field_key: row.fetch(:field_key)
            )
          end
        end
      end

      def field_label(project = self.project)
        FieldCatalog.label_for(field_key, project:)
      end

      def custom_field_id
        return unless field_key.to_s.start_with?("#{FIELD_PREFIX_CUSTOM}:")

        field_key.split(":", 2).last.to_i
      end

      private

      def field_key_must_exist_for_project
        return if field_key.blank? || project.blank?
        return if FieldCatalog.valid_key?(field_key, project:)

        errors.add(:field_key, I18n.t("openproject_work_package_required_fields.errors.invalid_field"))
      end
    end
  end
end
