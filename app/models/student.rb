class Student < ActiveRecord::Base
  belongs_to :group
  has_many :logged_messages, :as=>:sender, :dependent=>:nullify
  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.

  validates_phone_number :phone_number
  validates_uniqueness_of :phone_number, :scope=>:group_id
  validates_presence_of :name
end
