# frozen_string_literal: true

class FixCertificatesNextSerial < ActiveRecord::Migration[7.2]
  def up
    rename_column :certificates, :next_serial, :next_serial_s
    add_column :certificates, :next_serial, :string

    case ActiveRecord::Base.connection.adapter_name
    when "SQLite"
      # On SQLite, we can directly convert the numeric value to hex using printf
      execute "UPDATE certificates SET next_serial = printf('%X', CAST(next_serial_s AS integer)) WHERE next_serial_s IS NOT NULL"
    when "PostgreSQL"
      # On PostgreSQL, we need to convert the numeric value to bytea before encoding it as hex
      execute <<~SQL
        CREATE OR REPLACE FUNCTION numeric2bytea(_n NUMERIC) RETURNS BYTEA AS $$
        DECLARE
            _b BYTEA := '\\x';
            _v INTEGER;
        BEGIN
            WHILE _n > 0 LOOP
                _v := _n % 256;
                _b := SET_BYTE(('\\x00' || _b),0,_v);
                _n := (_n-_v)/256;
            END LOOP;
            RETURN _b;
        END;
        $$ LANGUAGE PLPGSQL IMMUTABLE STRICT;
      SQL
      execute "UPDATE certificates SET next_serial = encode(numeric2bytea(next_serial_s), 'hex')"
      execute "DROP FUNCTION numeric2bytea"
    else
      raise "Unsupported database adapter: #{ActiveRecord::Base.connection.adapter_name}"
    end

    remove_column :certificates, :next_serial_s
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "This migration cannot be reverted"
  end
end
