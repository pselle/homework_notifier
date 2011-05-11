class Group < ActiveRecord::Base
  belongs_to :user
  attr_readonly :user_id #after being set, can't change
  
  has_many :students, :dependent=>:destroy
  has_many :logged_messages, :dependent=>:nullify
  
  accepts_nested_attributes_for :students, :allow_destroy=>true, :reject_if=>:all_blank
  
  validates_phone_number :phone_number
  
  def send_message(message,sending_person,recipients=nil)
    recipients ||= students+[user] - [sending_person]
    sms_recipients,other_recipients = recipients.partition(&:phone_number) #in future, partition based on notification preferences AND availability of notifications
    
    #send sms messages to sms recipients
    numbers = sms_recipients.map(&:phone_number)
    $outbound_flocky.message phone_number, message, numbers
    
    #log sms outputs
    numbers.each do |destination|
      LoggedMessage.create(:group=>self,:sender=>sending_person,:source_phone=>phone_number,:destination_phone=>destination,:message=>message)
    end

    #todo: send message to non-sms recipients
  end
end
