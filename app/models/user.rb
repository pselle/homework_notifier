class User < ActiveRecord::Base
  #this represents, for now, a teacher with access to the system.
  #a user can create groups, and add students to those groups

  has_many :groups

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :display_name, :phone_number
  
  validates_presence_of :name, :if=>:confirmation_sent_at?
  validates_presence_of :display_name, :if=>:confirmation_sent_at?
  validates_format_of :phone_number, :with=>PHONE_FORMAT, :message=>PHONE_FORMAT_MESSAGE, :allow_nil=>true, :allow_blank=>true
  before_validation :massage_number, :if=>lambda {phone_number.present?}
  
  
  validates_presence_of :password_confirmation, :if=>:password_required?
  private
  def has_password?
    self.encrypted_password.present? or (self.password.present? and self.password_confirmation.present?)
  end
  def password_required?
    (confirmation_sent_at? && encrypted_password.blank?) || password.present? || password_confirmation.present?
  end
  def massage_number
    if !(phone_number =~ PHONE_FORMAT)
      if phone_number && (nums=phone_number.scan(/\d/)).length==10
        self.phone_number="(%s%s%s) %s%s%s-%s%s%s%s"%nums #is there a better way to write this?
      end
    end
  end
end
