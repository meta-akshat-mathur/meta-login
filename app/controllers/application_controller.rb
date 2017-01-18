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
    before_action :set_current_user, :send_params

    before_action :configure_permitted_parameters, if: :devise_controller?
    # after_filter :store_location

    def angular
        render 'layouts/application'
    end

    def handle_conflict_error
        render json: { errors: ['This record is updated by someone else. Please refresh and try again.'] }, status: 400
    end

    def send_params
      $resource_params = nil
      $resource_params = resource_params
      # $resource_params = User.get_params(resource_params)
    end

    def resource_name
        :user
    end

    # Description of method
    # => initializing @resource and including userlogin with it
    # @return [Type] description of returned object
    def resource
        @resource ||= User.include(:user_login).new
    end

    def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
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

        # parse header for values necessary for authentication
        uid = request.headers[uid_name] || params[uid_name]
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
        user = UserLogin.find_by_uid(uid).user

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

    private

    def set_current_user
        User.current = current_user
    end

    # def set_mailer_host
    #   ActionMailer::Base.default_url_options[:host] = request.host_with_port
    # end

    def resource_params
        params.permit(devise_parameter_sanitizer.for(:sign_in))
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.for(:sign_in)        << :mobile
        devise_parameter_sanitizer.for(:sign_in)        << :password
        devise_parameter_sanitizer.for(:sign_in)        << :email

        devise_parameter_sanitizer.for(:sign_up) << :first_name << :last_name << :mobile
    end
end
