class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students, :dependant=>:destroy

  validates_phone_number :phone_number
end
