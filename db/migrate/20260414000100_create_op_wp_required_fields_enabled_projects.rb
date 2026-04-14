class CreateOpWpRequiredFieldsEnabledProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :op_wp_required_fields_enabled_projects, if_not_exists: true do |t|
      t.references :project, null: false, index: { unique: true }, foreign_key: true

      t.timestamps
    end
  end
end
