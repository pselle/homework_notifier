class Student < ActiveRecord::Base
  has_many :memberships, :dependent=>:destroy
  has_many :groups, :through=> :memberships
  #for the moment, we expect standard, US-style 10 digit area code/number. we assume a country code of 1.
  validates_format_of :phone_number, :with=>PHONE_FORMAT, :message=>PHONE_FORMAT_MESSAGE
  
  before_validation :massage_number
  
  validates_uniqueness_of :phone_number
  validates_presence_of :name
  private
  
  #maybe this should be public, so javascript can call out to it, instead of reimplimenting the same logic in JS
  def massage_number
    if !(phone_number.to_s =~ PHONE_FORMAT)
      if phone_number && (nums=phone_number.scan(/\d/)).length==10
        self.phone_number="(%s%s%s) %s%s%s-%s%s%s%s"%nums #is there a better way to write this?
      end
    end
  end
end
