# require 'feature_permissions_jwt'
class ApplicationController < ActionController::Base
    # rescue_from ActiveRecord::StaleObjectError, :with => :handle_conflict_error
    protect_from_forgery
    include DeviseTokenAuth::Concerns::SetUserByToken

    # Prevent CSRF attacks by raising an exception.
    # For APIs, you may want to use :null_session instead.
    # protect_from_forgery with: :exception

    # before_action :authenticate_user!
    # before_filter :set_mailer_host
    before_action :set_current_user

    before_action :configure_permitted_parameters, if: :devise_controller?
    # after_filter :store_location

    def angular
        render 'layouts/application'
    end

    def handle_conflict_error
        render json: { errors: ['This record is updated by someone else. Please refresh and try again.'] }, status: 400
    end

    # Description of method
    # @Override method from SetUserByToken (concern)
    #
    # @param [Type] mapping = nil describe mapping = nil
    # @return [Type] description of returned object
    def set_user_by_token(mapping = nil)
        # determine target authentication class
        rc = resource_class(mapping)

        # no default user defined
        return unless rc

        # gets the headers names, which was set in the initialize file
        uid_name = DeviseTokenAuth.headers_names[:uid]
        access_token_name = DeviseTokenAuth.headers_names[:'access-token']
        client_name = DeviseTokenAuth.headers_names[:client]
        provider_name = DeviseTokenAuth.headers_names[:provider]

        # parse header for values necessary for authentication
        uid = request.headers[uid_name] || params[uid_name]
        provider = request.headers[provider_name] || params[provider_name]
        @token     ||= request.headers[access_token_name] || params[access_token_name]
        @client_id ||= request.headers[client_name] || params[client_name]

        # client_id isn't required, set to 'default' if absent
        @client_id ||= 'default'

        # check for an existing user, authenticated via warden/devise, if enabled
        if DeviseTokenAuth.enable_standard_devise_support
            devise_warden_user = warden.user(rc.to_s.underscore.to_sym)
            if devise_warden_user && devise_warden_user.tokens[@client_id].nil?
                @used_auth_by_token = false
                @resource = devise_warden_user
                @resource.create_new_auth_token
            end
        end

        # user has already been found and authenticated
        return @resource if @resource && (@resource.class == rc)

        # ensure we clear the client_id
        unless @token
            @client_id = nil
            return
        end

        return false unless @token

        # mitigate timing attacks by finding by uid instead of auth token
        # Override
        # find user from userlogin using UID
        user = uid && User.joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id").find_by('user_logins.provider = ? AND user_logins.uid = ?', provider,uid)

        # user = User.joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id").where('user_logins.provider = ? AND user_logins.uid = ?', provider,uid)
        # user = UserLogin.find_by(:uid => uid,:provider => provider).user

        if user && user.valid_token?(@token, @client_id)
            # sign_in with bypass: true will be deprecated in the next version of Devise
            if respond_to? :bypass_sign_in
                bypass_sign_in(user, scope: :user)
            else
                sign_in(:user, user, store: false, bypass: true)
            end
            
            return @resource = user
        else
            # zero all values previously set values
            @client_id = nil
            return @resource = nil
        end
    end

    def update_auth_header
    # cannot save object if model has invalid params
    return unless @resource and @resource.valid? and @client_id

    # Generate new client_id with existing authentication
    @client_id = nil unless @used_auth_by_token

    if @used_auth_by_token and not DeviseTokenAuth.change_headers_on_each_request
      # should not append auth header if @resource related token was
      # cleared by sign out in the meantime
      # override
      return if @resource.tokens[@client_id].nil?

      auth_header = @resource.build_auth_header(@token, @client_id)

      # update the response header
      response.headers.merge!(auth_header)

    else

      # Lock the user record during any auth_header updates to ensure
      # we don't have write contention from multiple threads
      @resource.with_lock do
        # should not append auth header if @resource related token was
        # cleared by sign out in the meantime
        return if @used_auth_by_token && @resource.tokens[@client_id].nil?

        # determine batch request status after request processing, in case
        # another processes has updated it during that processing
        @is_batch_request = is_batch_request?(@resource, @client_id)

        auth_header = {}

        # extend expiration of batch buffer to account for the duration of
        # this request
        if @is_batch_request
          auth_header = @resource.extend_batch_buffer(@token, @client_id)

        # update Authorization response header with new token
        else

          auth_header = @resource.create_new_auth_token(@client_id)

          # update the response header
          response.headers.merge!(auth_header)
        end

      end # end lock

    end

  end

    def resource_data(opts={})
      response_data = opts[:resource_json] || @resource.as_json
      if is_json_api
        response_data['type'] = @resource.class.name.parameterize
      end
      response_data
    end

    def resource_errors
      return @resource.errors.to_hash.merge(full_messages: @resource.errors.full_messages)
    end

    protected

    def params_for_resource(resource)
      devise_parameter_sanitizer.instance_values['permitted'][resource].each do |type|
        params[type.to_s] ||= request.headers[type.to_s] unless request.headers[type.to_s].nil?
      end
      devise_parameter_sanitizer.instance_values['permitted'][resource]
    end

    def resource_class(m=nil)
      if m
        mapping = Devise.mappings[m]
      else
        mapping = Devise.mappings[resource_name] || Devise.mappings.values.first
      end

      mapping.to
    end

    def is_json_api
      return false unless defined?(ActiveModel::Serializer)
      return ActiveModel::Serializer.setup do |config|
        config.adapter == :json_api
      end if ActiveModel::Serializer.respond_to?(:setup)
      return ActiveModelSerializers.config.adapter == :json_api
    end

    def configure_permitted_parameters
      permitted_parameters = devise_parameter_sanitizer.instance_values['permitted']
      permitted_parameters[:sign_up] << :first_name << :last_name << :mobile
      permitted_parameters[:sign_in] << :mobile
      permitted_parameters[:sign_in] << :password
      permitted_parameters[:sign_in] << :email

        # devise_parameter_sanitizer.for(:sign_in)        << :mobile
        # devise_parameter_sanitizer.for(:sign_in)        << :password
        # devise_parameter_sanitizer.for(:sign_in)        << :email
        #
        # devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name << :mobile
    end

    private

    def set_current_user
        User.current = current_user
    end

    # def set_mailer_host
    #   ActionMailer::Base.default_url_options[:host] = request.host_with_port
    # end

    # def resource_params
    #     params.permit(devise_parameter_sanitizer.for(:sign_in))
    # end
end
