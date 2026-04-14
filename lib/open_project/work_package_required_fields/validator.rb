module OpenProject
  module WorkPackageRequiredFields
    module Validator
      module_function

      def missing_field_labels(work_package)
        return [] unless status_transition?(work_package)
        return [] unless EnabledProject.enabled?(work_package.project_id)

        Rule.for_work_package(work_package).ordered.filter_map do |rule|
          rule.field_label(work_package.project) if FieldCatalog.blank?(work_package, rule.field_key)
        end.uniq
      end

      def status_transition?(work_package)
        return false unless work_package.project_id && work_package.type_id && work_package.status_id

        if work_package.respond_to?(:will_save_change_to_status_id?)
          work_package.will_save_change_to_status_id?
        elsif work_package.respond_to?(:status_id_changed?)
          work_package.status_id_changed?
        else
          false
        end
      end
    end
  end
end
