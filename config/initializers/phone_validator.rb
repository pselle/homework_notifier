ActiveRecord::Base.class_eval do

  def self.validates_phone_number(name,opts={})
    used_opts = {:with=>PhoneValidator::STORAGE_REGEX, :message=>PhoneValidator::FORMAT_ERROR_MESSAGE}.merge(opts)
    before_validation(:massage_number) unless used_opts.delete(:massage_number) == false
    validates_format_of(name, used_opts)
  end
  
  def massage_number
    if !(phone_number.to_s =~ PhoneValidator::STORAGE_REGEX)
      if phone_number && (nums=phone_number.scan(/\d/)).length==10
        self.phone_number=PhoneValidator::STORAGE_PRINTF%nums #is there a better way to write this?
      end
    end
  end#of massage number

end#of class eval