class MakeGroupPhoneNumberAString < ActiveRecord::Migration
  def self.up
    change_column :groups, :phone_number, :string
  end

  def self.down
    change_column :groups, :phone_number, :integer
  end
end
