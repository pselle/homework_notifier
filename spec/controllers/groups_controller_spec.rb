require 'spec_helper'

describe GroupsController do
  describe "authorization" do
    pending "all actions should be accessible to logged in users" do
    end
    pending "no actions should be accessible to non-logged-in users" do
    end
  end
  describe "#create" do
    before :each do
      login
    end    
    it "after successful create, should redirect to the edit memberships page" do
      post :create
      response.should redirect_to(edit_attributes_of_group_path(assigns[:group].id)) # Ugly hardcoded id !!
    end
  end
  
  before(:each) do
    login
    @group=Factory.create(:group)
    @member1 = Factory.create(:student)
    @group.students << @member1
  end
  
  describe "#update" do
    it "should create students based on passed in parameters" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]} }
      Student.find_by_name("Imma new guy").should_not be_nil #'should exist' doesn't seem to exist
      Student.find_by_name("Imma new guy").phone_number.should == "5551234567"
    end
    it "should automatically add those created students to the group" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      @group.students.count.should == 2
      @group.students.find_by_name("Imma new guy").should_not be_nil #'should exist' doesn't seem to exist
    end
    it "should not create a duplicate student, even if we forget to pass an id" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>@member1.name,:phone_number=>@member1.phone_number}]}}
      Student.find_all_by_phone_number(@member1.phone_number).count.should == 1
      @group.students.count.should == 1
    end
    it "should allow people to delete students from groups" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:id=>@member1.id,:_destroy=>'1'}]}}
      @group.reload
      @group.students.should be_empty
    end
    it "after deleting, should not have a deleted student in the assigned group's student list" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:id=>@member1.id,:_destroy=>'1'}]}}
      assigns[:group].students.should be_empty
    end
    
    it "on success, should redirect to edit page" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      response.should redirect_to(:edit_attributes_of_group)
    end
    it "on success, should have no errors" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}}
      assigns[:group].errors.should be_empty
    end
    
    it "should not create invalid students" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"",:phone_number=>"123"}]}}
      }.to_not change(Student,:count)
      @group.students.count.should == 1
    end
    it "should render back to edit with errors on invalid student" do
      put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"",:phone_number=>"123"}]}}
      assigns[:group].errors.should_not be_empty
    end
    
    it "should silently ignore blank entries" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"},{:name=>"",:phone_number=>""}]}}
      }.to change(Student,:count).by(1) #as opposed to 2
      
      @group.students.count.should == 2
      response.should redirect_to(:edit_attributes_of_group)
      assigns[:students].each {|s| s.errors.should be_empty}
    end
    
    it "should check for existing students, agnostic of original phone number input formatting" do
      expect {
        put :update, {:id=>@group.id, :group=>{:students_attributes=>[{:name=>@member1.name,:phone_number=>"___"+@member1.phone_number+"~~~"}]}}
      }.to_not change(Student,:count)
      @group.students.count.should == 1
    end
  end
  
  describe "send_message" do
    pending "should send a message to all group members" do
    end
    pending "should send a message delayed-like" do
    end
  end
  describe "receive_message" do
    pending "should send a message to all group members except original sender" do
    end
  end
  
end
