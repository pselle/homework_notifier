class User < ActiveRecord::Base
  #this represents, for now, a teacher with access to the system.
  #a user can create groups, and add students to those groups

  has_many :groups

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :display_name, :phone_number

end
