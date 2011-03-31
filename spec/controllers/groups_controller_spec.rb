require 'spec_helper'

describe GroupsController do
  describe "authorization" do
    pending "all actions should be accessible to logged in users" do
    end
    pending "no actions should be accessible to non-logged-in users" do
    end
  end
  describe "#create" do
    it "after successful create, should redirect to the edit memberships page" do
    end
  end
  describe "#update_memberships" do
    before(:each) do
      login
      @group=Factory.create(:group)
      @member1 = Factory.create(:student)
      @group.students << @member1
      @nonmember=Factory.create(:student)
    end
    it "should create students based on passed in parameters" do
      put :update_memberships, {:id=>@group.id, :students=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}
      Student.find_by_name("Imma new guy").should exist
      Student.find_by_name("Imma new guy").phone_number.should == "(555) 123-4567"
    end
    it "should automatically add those created students to the group" do
      put :update_memberships, {:id=>@group.id, :students=>[{:name=>"Imma new guy",:phone_number=>"555-123-4567"}]}
      @group.students.count.should == 2
      @group.students.find_by_name("Imma new guy").should exist
    end
    it "should not create a duplicate student" do
      put :update_memberships, {:id=>@group.id, :students=>[{:name=>@nonmember.name,:phone_number=>@nonmember.phone_number}]}
      Student.find_by_phone_number(@nonmember.phone_number).count.should == 1
    end
    it "should add existing students (which are found, not created) to the group" do
      put :update_memberships, {:id=>@group.id, :students=>[{:name=>@nonmember.name,:phone_number=>@nonmember.phone_number}]}
      @group.students.count.should == 2
      @group.students.should include(@nonmember)
    end
    pending "it should allow people to delete students from groups" do
    end
  end
end
