class Student < ActiveRecord::Base
  has_many :memberships, :dependent=>:destroy
  has_many :groups, :through=> :memberships
  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.

  validates_phone_number :phone_number
  validates_uniqueness_of :phone_number
  validates_presence_of :name
end
