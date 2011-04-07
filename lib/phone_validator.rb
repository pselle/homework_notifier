module PhoneValidator
  STORAGE_REGEX=/^\d{10}$/
  STORAGE_PRINTF="%s%s%s%s%s%s%s%s%s%s"
  FORMAT_ERROR_MESSAGE="phone number must be 10 digits, and of the form 'xxxxxxxxxx'"
  OUTPUT_PRINTF="(%s%s%s) %s%s%s-%s%s%s%s"
  def self.massage_number(phone_number)
    if !(phone_number.to_s =~ PhoneValidator::STORAGE_REGEX)
      if phone_number && (nums=phone_number.scan(/\d/)).length==10
        return PhoneValidator::STORAGE_PRINTF%nums #is there a better way to write this?
      end
    end
    return phone_number #else.
  end
end