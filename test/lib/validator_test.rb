require_relative "../test_helper"
require_relative "../../lib/open_project/work_package_required_fields/validator"

module OpenProject
  module WorkPackageRequiredFields
    class EnabledProject; end unless const_defined?(:EnabledProject)
    class Rule; end unless const_defined?(:Rule)
    module FieldCatalog; end unless const_defined?(:FieldCatalog)

    class ValidatorRuleRelation < Array
      def ordered
        self
      end
    end
  end
end

class ValidatorTest < Minitest::Test
  WorkPackageStub = Struct.new(:project_id, :type_id, :status_id, :project, :status_changed) do
    def will_save_change_to_status_id?
      status_changed
    end
  end

  class RuleStub
    attr_reader :field_key

    def initialize(field_key, label)
      @field_key = field_key
      @label = label
    end

    def field_label(_project)
      @label
    end
  end

  def setup
    @enabled_project_singleton = class << OpenProject::WorkPackageRequiredFields::EnabledProject; self; end
    @rule_singleton = class << OpenProject::WorkPackageRequiredFields::Rule; self; end
    @field_catalog_singleton = class << OpenProject::WorkPackageRequiredFields::FieldCatalog; self; end

    @enabled_project_singleton.send(:define_method, :enabled?) { |_project_id| true }
    @field_catalog_singleton.send(:define_method, :blank?) { |_work_package, field_key| field_key == "standard:subject" }
    @rule_singleton.send(:define_method, :for_work_package) do |_work_package|
      OpenProject::WorkPackageRequiredFields::ValidatorRuleRelation.new(
        [
          RuleStub.new("standard:subject", "Subject"),
          RuleStub.new("standard:due_date", "Due date")
        ]
      )
    end
  end

  def test_returns_missing_field_labels_for_matching_status_transition
    work_package = WorkPackageStub.new(1, 2, 3, Object.new, true)

    assert_equal ["Subject"], OpenProject::WorkPackageRequiredFields::Validator.missing_field_labels(work_package)
  end

  def test_skips_validation_without_status_transition
    work_package = WorkPackageStub.new(1, 2, 3, Object.new, false)

    assert_equal [], OpenProject::WorkPackageRequiredFields::Validator.missing_field_labels(work_package)
  end
end
