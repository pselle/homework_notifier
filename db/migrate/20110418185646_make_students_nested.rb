class MakeStudentsNested < ActiveRecord::Migration
  def self.up
    drop_table :memberships
    add_column :students, :group_id, :integer
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
