require_relative "../test_helper"

unless defined?(WorkPackage)
  class WorkPackage
    def self.human_attribute_name(attribute_name)
      attribute_name.to_s.tr("_", " ").capitalize
    end
  end
end

unless defined?(WorkPackageCustomField)
  class WorkPackageCustomField; end
end

require_relative "../../lib/open_project/work_package_required_fields/field_catalog"

class FieldCatalogTest < Minitest::Test
  CustomField = Struct.new(:id, :name)
  ProjectStub = Struct.new(:custom_fields) do
    def all_work_package_custom_fields
      custom_fields
    end
  end

  def test_valid_key_accepts_known_standard_field
    project = ProjectStub.new([])

    assert OpenProject::WorkPackageRequiredFields::FieldCatalog.valid_key?("standard:subject", project: project)
  end

  def test_valid_key_accepts_known_custom_field
    project = ProjectStub.new([CustomField.new(7, "Environment")])

    assert OpenProject::WorkPackageRequiredFields::FieldCatalog.valid_key?("custom:7", project: project)
  end

  def test_valid_key_rejects_unknown_field
    project = ProjectStub.new([CustomField.new(7, "Environment")])

    refute OpenProject::WorkPackageRequiredFields::FieldCatalog.valid_key?("custom:999", project: project)
    refute OpenProject::WorkPackageRequiredFields::FieldCatalog.valid_key?("totally:made-up", project: project)
  end
end
