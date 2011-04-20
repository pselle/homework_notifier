require 'spec_helper'

describe StudentsController do
  describe "authorization" do
    pending "all actions should be accessible to logged in users" do
    end
    pending "no actions should be accessible to non-logged-in users" do
    end
  end
  
  describe "find_or_create" do
    before(:each) do
      login
      @student = Factory.create(:student)
    end
    
    it "should create students based on passed in parameters" do
      put :find_or_create, {:student=>{:name=>"Imma new guy",:phone_number=>"555-123-4567"}}, :format=>'xml'
      Student.find_by_name("Imma new guy").should_not be_nil #'should exist' doesn't seem to exist
      Student.find_by_name("Imma new guy").phone_number.should == "5551234567"
    end
    
    it "should not create a duplicate student" do
      expect {
      	put :find_or_create, {:student=>{:name=>@student.name,:phone_number=>@student.phone_number}}, :format=>'xml'
      }.to_not change(Student,:count)
      Student.find_all_by_phone_number(@student.phone_number).count.should == 1
    end
    
    it "should find existing students" do
      put :find_or_create, {:student=>{:name=>@student.name,:phone_number=>@student.phone_number}}, :format=>'xml'
      assigns[:student].should_not be_nil
      assigns[:student].should == @student
    end
    
    it "should not create invalid students" do
      expect {
        put :find_or_create, {:student=>{:name=>"",:phone_number=>"123"}}, :format=>'xml'
      }.to_not change(Student,:count)
    end

    it "should return with errors on invalid student" do
      put :find_or_create, {:student=>{:name=>"",:phone_number=>"123"}}, :format=>'xml'
      assigns[:student].errors.should_not be_empty
    end
    
    #this is based on a found bug:
    it "should find existing students, agnostic of original phone number input formatting" do
      put :find_or_create, {:student=>{:name=>@student.name,:phone_number=>"5 5 5 1 2 3 4 5 6 7"}}, :format=>'xml'
      assigns[:student].should_not be_nil
      assigns[:student].phone_number.should == "5551234567"
    end

  end
end
