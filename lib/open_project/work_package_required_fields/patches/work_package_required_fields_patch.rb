module OpenProject
  module WorkPackageRequiredFields
    module Patches
      module WorkPackageRequiredFieldsPatch
        def self.prepended(base)
          base.class_eval do
            scope :with_required_fields_rules, -> { all }
          end
        end
      end
    end
  end
end
