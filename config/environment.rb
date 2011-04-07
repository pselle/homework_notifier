# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HomeworkNotifier::Application.initialize!
PHONE_FORMAT=/^\(\d{3}\) \d{3}-\d{4}$/
PHONE_FORMAT_MESSAGE="phone number must be 10 digits, and of the form '(xxx) xxx-xxxx'"
$outbound_flocky = Flocky.new ENV['FLOCKY_SMS'],ENV['FLOCKY_TOKEN'], :queue => false
