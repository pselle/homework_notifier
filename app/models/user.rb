class User < ActiveRecord::Base
  #this represents, for now, a teacher with access to the system.
  #a user can create groups, and add students to those groups

  has_many :groups

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :display_name, :phone_number
  
  validates_presence_of :name, :if=>:confirmation_sent_at?
  validates_presence_of :display_name, :if=>:confirmation_sent_at?
  validates_phone_number :phone_number, :allow_nil=>true, :allow_blank=>true
  
  validates_presence_of :password_confirmation, :if=>:password_required?
  private
  def has_password?
    self.encrypted_password.present? or (self.password.present? and self.password_confirmation.present?)
  end
  def password_required?
    (confirmation_sent_at? && encrypted_password.blank?) || password.present? || password_confirmation.present?
  end
end
