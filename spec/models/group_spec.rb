require 'spec_helper'

describe Group do
  before(:each) do
    @group = Factory.create(:group)
  end

  describe "their phone number" do
    it "may NOT be blank" do
      @group.phone_number=nil
      @group.should_not be_valid
      @group.phone_number=""
      @group.should_not be_valid
    end
    it "if present, must be valid" do
      @group.phone_number="abc123"
      @group.should_not be_valid
      @group.phone_number="(123) 456-7890"
      @group.should be_valid
      @group.phone_number="1234567891"
      @group.should be_valid
    end
  end
  
  describe "send_message" do
    before :each do
      @email_student=Factory.create(:student,:email=>"abc@def.com", :phone_number=>nil)
      @group.students << @email_student
    end
    it "should send emails to users without phone numbers" do
      NotificationMailer.should_receive(:notification_email).with(/test message/,@email_student,@group)
      @group.send_message("test message",@group.user)
    end
  end
end