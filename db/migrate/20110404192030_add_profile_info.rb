class AddProfileInfo < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :name
      t.string :phone_number
      t.string :display_name
    end
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :phone_number
    remove_column :users, :display_name
  end
end
