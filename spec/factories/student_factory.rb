
Factory.define(:student) do |s|
  s.sequence(:name) {|n| "student_barcode_number_#{n}"}
  s.sequence(:phone_number) {|n|"%0.10d"%n }
end