require_relative "../test_helper"
require_relative "../../lib/open_project/work_package_required_fields/project_access"

class ProjectAccessTest < Minitest::Test
  ProjectStub = Struct.new(:id)

  class UserStub
    def initialize(admin: false, allowed_permissions: [])
      @admin = admin
      @allowed_permissions = allowed_permissions
    end

    def admin?
      @admin
    end

    def allowed_in_project?(permission, _project)
      @allowed_permissions.include?(permission)
    end
  end

  def test_allows_global_admin
    user = UserStub.new(admin: true)

    assert OpenProject::WorkPackageRequiredFields::ProjectAccess.allowed?(user, ProjectStub.new(1))
  end

  def test_allows_edit_project_permission
    user = UserStub.new(allowed_permissions: [:edit_project])

    assert OpenProject::WorkPackageRequiredFields::ProjectAccess.allowed?(user, ProjectStub.new(1))
  end

  def test_rejects_manage_members_without_project_settings_permissions
    user = UserStub.new(allowed_permissions: [:manage_members])

    refute OpenProject::WorkPackageRequiredFields::ProjectAccess.allowed?(user, ProjectStub.new(1))
  end

  def test_rejects_select_project_attributes_without_project_settings_permissions
    user = UserStub.new(allowed_permissions: [:select_project_attributes])

    refute OpenProject::WorkPackageRequiredFields::ProjectAccess.allowed?(user, ProjectStub.new(1))
  end
end

