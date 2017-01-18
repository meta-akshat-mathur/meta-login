# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

  ActionMailer::Base.smtp_settings = {
      :user_name => 'connect@tpohub.com',
      :password => 'sBkADhuuxC9L7VlAteP98Q',
      :domain => 'metaplacement.in',
      :address => 'smtp.mandrillapp.com',
      :port => 587,
      :authentication => :plain,
      :enable_starttls_auto => true
  }

  # MANDRILL_USERNAME: "connect@tpohub.com"
  # MANDRILL_APIKEY: "sBkADhuuxC9L7VlAteP98Q"
