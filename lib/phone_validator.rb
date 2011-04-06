module PhoneValidator
  STORAGE_REGEX=/^\d{10}$/
  STORAGE_PRINTF="%s%s%s%s%s%s%s%s%s%s"
  FORMAT_ERROR_MESSAGE="phone number must be 10 digits, and of the form 'xxxxxxxxxx'"
  OUTPUT_PRINTF="(%s%s%s) %s%s%s-%s%s%s%s"
end