require 'spec_helper'

describe Student do
  before(:each) do
    @student = Factory.create(:student)
  end

  describe "their phone number" do
    it "must be 10 digits" do
      @student.phone_number.scan(/\d/).length.should == 10
    end
    it "must be in the canonical format" do
      @student.phone_number.should match(/^\(\d{3}\) \d{3}-\d{4}$/)
    end
    it "should automatically be converted to the canonical format, agnostic of valid-ish input" do
      Factory.create(:student, :phone_number=>"5551234567").phone_number.should == "(555) 123-4567"
    end
    it "must be unique" do
      Factory.build(:student,:phone_number=>@student.phone_number).should_not be_valid
    end
  end
  describe "their name" do
    it "must be present" do
      Factory.build(:student,:name=>nil).should_not be_valid
    end
    it "can't be set to blank" do
      Factory.build(:student,:name=>"").should_not be_valid
    end
    it "might not be unique" do
      Factory.create(:student,:name=>@student.name).should be_valid
    end
  end
  describe "their group memberships" do
    pending "students can be members of no groups" do
    end
    pending "students can be members of exactly one group" do
    end
    pending "students can be members of multiple groups" do
    end
    pending "students can't be in the same group twice at the same time" do
    end
  end
end