class CreateLoggedMessages < ActiveRecord::Migration
  def self.up
    create_table :logged_messages do |t|
      t.references :group
      t.references :sender, :polymorphic=>true
      t.string :source_phone
      t.string :destination_phone
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :logged_messages
  end
end
