class Group < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent=>:destroy
  has_many :students, :through=> :memberships

  validates_phone_number :phone_number, :allow_nil=>true, :allow_blank=>true
end
