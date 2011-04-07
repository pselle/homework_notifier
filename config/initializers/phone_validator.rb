ActiveRecord::Base.class_eval do

  def self.validates_phone_number(name,opts={})
    used_opts = {:with=>PhoneValidator::STORAGE_REGEX, :message=>PhoneValidator::FORMAT_ERROR_MESSAGE}.merge(opts)
    before_validation(:massage_my_number!) unless used_opts.delete(:massage_number) == false
    validates_format_of(name, used_opts)
  end
  
  def massage_my_number!
    self.phone_number=PhoneValidator::massage_number(self.phone_number)
  end

end#of class eval