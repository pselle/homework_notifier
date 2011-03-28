class Student < ActiveRecord::Base
  has_many :memberships, :dependent=>:destroy
  has_many :groups, :through=> :memberships
  PHONE_REGEX=/^\(\d{3}\) \d{3}-\d{4}$/
  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.
  validates_format_of :phone_number, :with=>PHONE_REGEX, :message=>"phone number must be 10 digits, and of the form '(xxx) xxx-xxxx'"
  
  before_validation :massage_number
  
  private
  
  #maybe this should be public, so javascript can call out to it, instead of reimplimenting the same logic in JS
  def massage_number
    if !(phone_number =~ PHONE_REGEX)
      if (nums=phone_number.scan(/\d/)).length==10
        self.phone_number="(%s%s%s) %s%s%s-%s%s%s%s"%nums #is there a better way to write this?
      end
    end
  end
end
