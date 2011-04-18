class Group < ActiveRecord::Base
  belongs_to :user
  has_many :students

  validates_phone_number :phone_number
end
