Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook,      '1065962046831358', '1bbe65369377c24e91f2adb7e2bbb7c9',
    :scope => 'email', :display => 'popup', :info_fields => 'first_name,email'
  provider :google_oauth2, '391853269177-u4e9sn6b07g15kdj50c0538s4fkd86dd.apps.googleusercontent.com',   'tO66FuQCuBdRpNsd3w4HIB1W',
    :scope => 'email', :display => 'popup', :info_fields => 'first_name,email'
  provider :linkedin, '751xc30t8aea4j', 'y7TBOwgqz0F0PDdh'
end
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

# FACEBOOK_KEY: "1065962046831358"
# FACEBOOK_SECRET: "1bbe65369377c24e91f2adb7e2bbb7c9"
# GOOGLE_KEY: "391853269177-u4e9sn6b07g15kdj50c0538s4fkd86dd.apps.googleusercontent.com"
# GOOGLE_SECRET: "tO66FuQCuBdRpNsd3w4HIB1W"
# LINKEDIN_KEY: "751xc30t8aea4j"
# LINKEDIN_SECRET: "y7TBOwgqz0F0PDdh"
