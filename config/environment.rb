# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HomeworkNotifier::Application.initialize!
$outbound_flocky = Flocky.new ENV['FLOCKY_SMS'],ENV['FLOCKY_TOKEN'], :queue => false
