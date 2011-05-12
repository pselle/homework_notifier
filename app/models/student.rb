class Student < ActiveRecord::Base
  belongs_to :group
  has_many :logged_messages, :as=>:sender, :dependent=>:nullify
  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.

  validates_phone_number :phone_number, :allow_blank=>true
  validates_uniqueness_of :phone_number, :scope=>:group_id, :allow_blank=>true, :allow_nil=>true
  
  validates_presence_of :name
  
  validate :notification_method_present?
  
  def notification_method_present?
    errors.add(:base,"either phone_number or email must be present") unless [phone_number,email].any?(&:present?)
  end
end
