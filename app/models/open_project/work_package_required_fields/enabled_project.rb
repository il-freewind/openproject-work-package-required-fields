module OpenProject
  module WorkPackageRequiredFields
    class EnabledProject < ::ApplicationRecord
      self.table_name = "op_wp_required_fields_enabled_projects"

      belongs_to :project

      validates :project_id, presence: true, uniqueness: true

      scope :ordered, -> { joins(:project).merge(Project.order(:name)) }

      def self.enabled?(project_or_id)
        project_id = project_or_id.respond_to?(:id) ? project_or_id.id : project_or_id

        exists?(project_id:)
      end

      def self.replace_all!(project_ids)
        ids = Array(project_ids).map(&:presence).compact.map(&:to_i).uniq

        transaction do
          delete_all
          ids.each { |project_id| create!(project_id:) }
        end
      end
    end
  end
end
