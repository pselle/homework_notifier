class AddPhoneNumberToGroup < ActiveRecord::Migration
  def self.up
		add_column :groups, :phone_number, :integer
  end

  def self.down
		remove_column :groups, :phone_number
  end
end
