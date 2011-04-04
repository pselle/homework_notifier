Factory.define(:user) do |u|
  u.sequence(:email) {|n| "email_#{n}@company.com"}
  u.password "a_password"
end