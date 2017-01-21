DeviseTokenAuth.setup do |config|
  # By default the authorization headers will change after each request. The
  # client is responsible for keeping track of the changing tokens. Change
  # this to false to prevent the Authorization header from changing after
  # each request.
  config.change_headers_on_each_request = false

  config.check_current_password_before_update = :password

  config.headers_names = {:'access-token' => 'access-token',
                         :'client' => 'client',
                        :'expiry' => 'expiry',
                         :'uid' => 'uid',
                         :'provider' => 'provider',
                         :'token-type' => 'token-type' }

  #By default, old tokens are not invalidated when password is changed.
  #By enabling this option, it will remove old tokens and logout from other devises.
  config.remove_tokens_after_password_reset = true
  # config.remove_tokens = true

  # By default, users will need to re-authenticate after 2 weeks. This setting
  # determines how long tokens will remain valid after they are issued.
  # config.token_lifespan = 6.hours

  # Sometimes it's necessary to make several requests to the API at the same
  # time. In this case, each request in the batch will need to share the same
  # auth token. This setting determines how far apart the requests can be while
  # still using the same auth token.
  #config.batch_request_buffer_throttle = 5.seconds

  # This route will be the prefix for all oauth2 redirect callbacks. For
  # example, using the default '/omniauth', the github oauth2 provider will
  # redirect successful authentications to '/omniauth/github/callback'
  #config.omniauth_prefix = "/omniauth"

end
