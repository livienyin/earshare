# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EarshareApp::Application.initialize!

EarshareApp::Application.configure do
  config.last_fm_api_key = ENV["LAST_FM_API_KEY"]
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587, 
    :domain => "mysite.com",
    :user_name => "livienyin",
    :password => ENV['GMAIL_PASSWORD'],
    :authentication => "plain",
    :enable_starttls_auto => true,
  }
  # DO care
  config.action_mailer.raise_delivery_errors = true
end
