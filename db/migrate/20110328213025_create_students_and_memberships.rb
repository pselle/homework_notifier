class CreateStudentsAndMemberships < ActiveRecord::Migration
  def self.up
    create_table :students do |t|
      t.string :name
      t.string :phone_number

      t.timestamps
    end
    create_table :memberships do |t|
      t.references :group
      t.references :student
      t.timestamps
    end
    add_index :memberships, [:group_id,:student_id], :name=>:membership_pair, :unique=>true
  end

  def self.down
    drop_table :students
    drop_table :memberships
  end
end
