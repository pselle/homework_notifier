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
    it "after successful create, should redirect to the edit page" do
      post :create
      response.should redirect_to(edit_group)
    end
  end
  
  before(:each) do
    login
    @group=Factory.create(:group)
    @member1 = Factory.create(:student)
    @group.students << @member1
  end
  
  describe "boilerplate functionality" do
    describe "index"
      it "should set @groups" do
        get :index
        assigns[:groups].should_not be_nil
      end
      pending "should be limited to currently logged in user's groups only" do
      end
    end
    
    describe "show/edit" do
      it "should set @group and a @page_title" do
      [:show,:edit].each do |meth|
        get meth, {:id=>@group.id}
        assigns[:group].should_not be_nil
        assigns[:page_title].should_not be_nil
      end
      pending "should only show if it's the currently logged in user's group" do
      end
    end
    
    it "new should give us a new @group" do
      get :new
      assigns[:group].should_not be_nil
      assigns[:group].should be_new_record
    end
    describe "delete" do
      it "should delete group, and dependent students" do
        expect {
          delete :destroy, {:id=>@group.id}
        }.to change(Student,:count).by(-1)
        Group.find_by_id(@group.id).should be_nil
      end
      pending "should only delete if it's the currently logged in user's group" do
      end
      
    end
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
      response.should redirect_to(:edit_group)
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
      response.should redirect_to(:edit_group)
      assigns[:group].errors.should be_empty
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
