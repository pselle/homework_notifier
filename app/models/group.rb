class Group < ActiveRecord::Base
  belongs_to :user
  attr_readonly :user_id #after being set, can't change
  
  has_many :students, :dependent=>:destroy
  
  accepts_nested_attributes_for :students, :allow_destroy=>true, :reject_if=>:all_blank
  
  validates_phone_number :phone_number
  
  
end
