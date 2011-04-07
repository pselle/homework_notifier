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
end