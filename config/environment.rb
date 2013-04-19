# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
EarshareApp::Application.initialize!

EarshareApp::Application.configure do
  config.last_fm_api_key = ENV["LAST_FM_API_KEY"]
end
