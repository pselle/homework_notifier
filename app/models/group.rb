class Group < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent=>:destroy
  has_many :students, :through=> :memberships
end
