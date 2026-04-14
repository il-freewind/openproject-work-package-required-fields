class CreateOpWpRequiredFieldsRules < ActiveRecord::Migration[7.0]
  def change
    create_table :op_wp_required_fields_rules, if_not_exists: true do |t|
      t.references :project, null: false, foreign_key: true
      t.references :type, null: false, foreign_key: true
      t.references :status, null: false, foreign_key: true
      t.string :field_key, null: false

      t.timestamps
    end

    add_index :op_wp_required_fields_rules,
              %i[project_id type_id status_id field_key],
              unique: true,
              name: "index_op_wp_required_fields_rules_uniqueness",
              if_not_exists: true
  end
end
