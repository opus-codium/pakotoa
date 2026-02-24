# frozen_string_literal: true

class CreatePolicies < ActiveRecord::Migration[4.2]
  def change
    create_table :policies do |t|
      t.string :name

      t.timestamps
    end

    # Existing data would be broken
    truncate :subject_attributes

    add_column :certificates, :policy_id, :integer
    rename_column :subject_attributes, :certificate_authority_id, :policy_id
    rename_column :subject_attributes, :policy, :strategy
  end
end
