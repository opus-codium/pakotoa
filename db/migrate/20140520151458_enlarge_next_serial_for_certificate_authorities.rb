# frozen_string_literal: true

class EnlargeNextSerialForCertificateAuthorities < ActiveRecord::Migration[4.2]
  def up
    change_column :certificates, :next_serial, :numeric, precision: 20
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted"
  end
end
