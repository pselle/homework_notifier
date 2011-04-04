class Group < ActiveRecord::Base
  belongs_to :user
  has_many :memberships, :dependent=>:destroy
  has_many :students, :through=> :memberships
  validates_format_of :phone_number, :with=>PHONE_FORMAT, :message=>PHONE_FORMAT_MESSAGE, :allow_nil=>true, :allow_blank=>true
  before_validation :massage_number, :if=>lambda {phone_number.present?}
  
  private
  def massage_number
    if !(phone_number =~ PHONE_FORMAT)
      if phone_number && (nums=phone_number.scan(/\d/)).length==10
        self.phone_number="(%s%s%s) %s%s%s-%s%s%s%s"%nums #is there a better way to write this?
      end
    end
  end
end
