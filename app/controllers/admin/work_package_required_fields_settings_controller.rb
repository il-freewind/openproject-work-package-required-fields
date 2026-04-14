module Admin
  class WorkPackageRequiredFieldsSettingsController < ::ApplicationController
    before_action :require_admin

    def show
      load_projects
    end

    def update
      OpenProject::WorkPackageRequiredFields::EnabledProject.replace_all!(enabled_project_ids)

      redirect_to admin_work_package_required_fields_settings_path,
                  notice: I18n.t("openproject_work_package_required_fields.flash.admin_updated")
    rescue ActiveRecord::ActiveRecordError => e
      load_projects
      flash.now[:error] = e.message
      render :show, status: :unprocessable_entity
    end

    private

    def load_projects
      @projects = Project.order(:name).to_a
      @enabled_project_ids = OpenProject::WorkPackageRequiredFields::EnabledProject.pluck(:project_id)
    end

    def enabled_project_ids
      Array(params[:enabled_project_ids]).map(&:presence).compact
    end
  end
end
