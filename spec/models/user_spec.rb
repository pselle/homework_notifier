require 'spec_helper'
#factory girl doesn't play nice with user.

describe User do
  pending "is not registerable" do
    #this might be a controller test?
  end
  it "can be created manually" do
    expect{User.create(:email=>"bob@zombo.com")}.to change(User,:count).by(1)
  end
  it "doesn't require info before confirmation" do
    u=User.new(:email=>"email@yeaaah.com")
    u.name.should be_blank
    u.phone_number.should be_blank
    u.encrypted_password.should be_blank
    u.password.should be_blank
    u.should be_valid
  end
  it "does require profile info after confirmation email is sent" do
    u=User.create(:email=>"email@yeaaah.com")
    u.should_not be_valid
  end
  it "can be confirmed" do
    u=User.create(:email=>"email@yeaaah.com")
    u.confirm!
    u.should be_confirmed
  end
  pending "disallows sign-in before confirmation" do
  end
  describe "their phone number, after confirmation" do
    before(:each) do
      @user=User.create(:email=>"hi@hi.com",:name=>"testguy",:display_name=>"j",:password=>"yeaaah",:password_confirmation=>"yeaaah")
      @user.confirm!
    end
    it "may be blank" do
      @user.phone_number=nil
      @user.should be_valid
    end
    it "if present, must be of the canonical format" do
      @user.phone_number="abc123"
      @user.should_not be_valid
      @user.phone_number="(123) 456-7890"
      @user.should be_valid
      @user.phone_number="1234567891"
      @user.should be_valid
    end
  end
  
  describe "their password" do
  end
end