
Factory.define(:group) do |g|
  g.sequence(:title) {|n| "group_number_#{n}"}
  g.sequence(:phone_number) {|n|"%0.10d"%n }
  g.association :user
end