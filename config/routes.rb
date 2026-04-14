OpenProject::Application.routes.draw do
  namespace :admin do
    scope "settings/work_packages_general" do
      resource :work_package_required_fields_settings,
               only: %i[show update],
               path: "required_fields"
    end
  end

  resources :projects, only: [] do
    scope module: :projects, path: "settings" do
      resource :work_package_required_fields_settings,
               only: %i[show update],
               path: "required_fields"
    end
  end

  get "projects/:project_id/settings/general/required_fields",
      to: "projects/work_package_required_fields_settings#show"
  put "projects/:project_id/settings/general/required_fields",
      to: "projects/work_package_required_fields_settings#update"
  get "projects/:project_id/settings/work_packages/required_fields",
      as: :project_settings_work_packages_required_fields,
      to: "projects/work_package_required_fields_settings#show"
  put "projects/:project_id/settings/work_packages/required_fields",
      to: "projects/work_package_required_fields_settings#update"
end
