module OpenProject
  module WorkPackageRequiredFields
    class LayoutHooks < OpenProject::Hook::ViewListener
      render_on :view_layouts_base_html_head,
                partial: "hooks/work_package_required_fields/reload_on_validation_error"
    end
  end
end
