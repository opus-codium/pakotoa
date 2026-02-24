class AddIndexOnOidName < ActiveRecord::Migration[7.2]
  def change
    add_index :oids, :name, unique: true
  end
end
