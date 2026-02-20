# frozen_string_literal: true

class FixCertificatesNextSerial < ActiveRecord::Migration[7.2]
  def up
    rename_column :certificates, :next_serial, :next_serial_s
    add_column :certificates, :next_serial, :string
    execute "UPDATE certificates SET next_serial = printf('%X', CAST(next_serial_s AS integer)) WHERE next_serial_s IS NOT NULL"
    remove_column :certificates, :next_serial_s
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted"
  end
end
