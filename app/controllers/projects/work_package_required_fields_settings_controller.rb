module Projects
  class WorkPackageRequiredFieldsSettingsController < ::ApplicationController
    before_action :find_project
    before_action :authorize_project_admin!
    before_action :ensure_plugin_enabled_for_project!
    before_action :load_form_dependencies

    authorization_checked! :show, :update
    menu_item :settings_work_packages

    def show
      @rows = persisted_rows
      @rows << blank_row if @rows.empty?
    end

    def update
      @rows = sanitized_rows!

      if @rows.empty?
        OpenProject::WorkPackageRequiredFields::Rule.where(project_id: @project.id).delete_all

        redirect_to project_settings_work_packages_required_fields_path(@project),
                    notice: I18n.t("openproject_work_package_required_fields.flash.project_updated")
        return
      end

      OpenProject::WorkPackageRequiredFields::Rule.replace_for_project!(@project, @rows)

      redirect_to project_settings_work_packages_required_fields_path(@project),
                  notice: I18n.t("openproject_work_package_required_fields.flash.project_updated")
    rescue ArgumentError, KeyError, ActiveRecord::ActiveRecordError => e
      flash.now[:error] = e.message
      @rows = preview_rows.presence || [blank_row]
      render :show, status: :unprocessable_entity
    end

    private

    def find_project
      @project = Project.find(params[:project_id])
    end

    def authorize_project_admin!
      return if OpenProject::WorkPackageRequiredFields::ProjectAccess.allowed?(User.current, @project)

      render_403
    end

    def ensure_plugin_enabled_for_project!
      return if OpenProject::WorkPackageRequiredFields::EnabledProject.enabled?(@project)

      redirect_to project_settings_path(@project), alert: I18n.t("openproject_work_package_required_fields.flash.project_not_enabled")
    end

    def load_form_dependencies
      @types = available_types
      @statuses = available_statuses
      @field_options = OpenProject::WorkPackageRequiredFields::FieldCatalog.grouped_options(project: @project)
      @existing_rules = OpenProject::WorkPackageRequiredFields::Rule.where(project_id: @project.id).ordered.to_a
    end

    def available_types
      return @project.types.to_a if @project.respond_to?(:types)
      return Type.order(:name).to_a if defined?(Type)

      []
    end

    def available_statuses
      if defined?(Status) && Status.respond_to?(:order)
        Status.order(:position, :name).to_a
      elsif defined?(Status)
        Status.all.to_a
      else
        []
      end
    end

    def persisted_rows
      @existing_rules.map do |rule|
        {
          type_id: rule.type_id,
          status_id: rule.status_id,
          field_key: rule.field_key
        }
      end
    end

    def blank_row
      {
        type_id: nil,
        status_id: nil,
        field_key: nil
      }
    end

    def sanitized_rows!
      Array(params[:rules]).filter_map do |rule|
        next unless rule.is_a?(ActionController::Parameters) || rule.is_a?(Hash)

        type_id = rule[:type_id].presence
        status_id = rule[:status_id].presence
        field_key = rule[:field_key].presence

        next if [type_id, status_id, field_key].all?(&:blank?)
        if [type_id, status_id, field_key].any?(&:blank?)
          raise ArgumentError, I18n.t("openproject_work_package_required_fields.errors.incomplete_rule")
        end
        unless OpenProject::WorkPackageRequiredFields::FieldCatalog.valid_key?(field_key, project: @project)
          raise ArgumentError, I18n.t("openproject_work_package_required_fields.errors.invalid_field")
        end

        {
          type_id: type_id.to_i,
          status_id: status_id.to_i,
          field_key:
        }
      end
    end

    def preview_rows
      Array(params[:rules]).filter_map do |rule|
        next unless rule.is_a?(ActionController::Parameters) || rule.is_a?(Hash)

        {
          type_id: rule[:type_id].presence&.to_i,
          status_id: rule[:status_id].presence&.to_i,
          field_key: rule[:field_key].presence
        }
      end
    end
  end
end
