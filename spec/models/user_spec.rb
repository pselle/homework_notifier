require 'spec_helper'

describe User do
  pending "is not registerable" do
    #this might be a controller test?
  end
  it "can be created manually" do
    expect{Factory.create(:user)}.to change(User,:count).by(1)
  end
  it "doesn't require info before confirmation" do
    u=Factory.create(:user)
    u.name.should be_nil
    u.should be_valid
  end
  pending "does require profile info after confirmation" do
  end
  pending "can be confirmed" do
  end
  pending "disallows sign-in before confirmation" do
  end
end