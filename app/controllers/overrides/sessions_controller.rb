# app/controllers/overrides/sessions_controller.rb
module Overrides
    class SessionsController < DeviseTokenAuth::SessionsController
        before_action :set_user_by_token, only: [:destroy]
        after_action :reset_session, only: [:destroy]

        def new
            render_new_error
        end

        # Create session
        ## @see create_permission_token
        # @return [Type] description of returned object
        def create
            # Check
            field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

            @resource = nil
            if field
                q_value = resource_params[field]

                if resource_class.case_insensitive_keys.include?(field)
                    q_value.downcase!
                end

                #  q = "#{field.to_s} = ? AND provider='email'"

                # @Override
                # Removed check for provider
                q = "#{field} = ?"
                # q+= " AND is_mobile_verified = true" if field.to_s == "mobile_no"

                if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
                    q = 'BINARY ' + q
                end
                @resource = resource_class.joins(:user_logins).joins(:user_logins).select('*',"user_logins.id as user_login_id","users.id as id").where('user_logins.uid = ?', q_value).where(q, q_value).first
            end

            if @resource && valid_params?(field, q_value) && @resource.valid_password?(resource_params[:password]) && (!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
                # create client id
                @client_id = SecureRandom.urlsafe_base64(nil, false)
                @token = SecureRandom.urlsafe_base64(nil, false)

                @resource.tokens[@client_id] = {
                    token: BCrypt::Password.create(@token),
                    expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
                }

                @resource.save

                sign_in(:user, @resource, store: false, bypass: false)

                yield if block_given?

                render_create_success
            elsif @resource && !(!@resource.respond_to?(:active_for_authentication?) || @resource.active_for_authentication?)
                render_create_error_not_confirmed
            else
                render_create_error_bad_credentials
            end
        end

        def destroy
            # remove auth instance variables so that after_filter does not run
            user = remove_instance_variable(:@resource) if @resource
            client_id = remove_instance_variable(:@client_id) if @client_id
            remove_instance_variable(:@token) if @token

            if user && client_id && user.tokens[client_id]
                user.tokens.delete(client_id)
                user.save!

                yield if block_given?

                render_destroy_success
            else
                render_destroy_error
            end
        end

        protected

        def valid_params?(key, val)
            resource_params[:password] && key && val
        end

        def get_auth_params
            auth_key = nil
            auth_val = nil

            # iterate thru allowed auth keys, use first found
            resource_class.authentication_keys.each do |k|
                next unless resource_params[k]
                auth_val = resource_params[k]
                auth_key = k
                break
            end

            # honor devise configuration for case_insensitive_keys
            if resource_class.case_insensitive_keys.include?(auth_key)
                auth_val.downcase!
            end

            {
                key: auth_key,
                val: auth_val
            }
        end

        def render_new_error
            render json: {
                errors: [I18n.t('devise_token_auth.sessions.not_supported')]
            }, status: 405
        end

        def render_create_success
            render json: {
                data: @resource.token_validation_response
            }
        end

        def render_create_error_not_confirmed
            render json: {
                success: false,
                errors: [I18n.t('devise_token_auth.sessions.not_confirmed', email: @resource.email)]
            }, status: 401
        end

        def render_create_error_bad_credentials
            render json: {
                errors: [I18n.t('devise_token_auth.sessions.bad_credentials')]
            }, status: 401
        end

        def render_destroy_success
            render json: {
                success: true
            }, status: 200
        end

        def render_destroy_error
            render json: {
                errors: [I18n.t('devise_token_auth.sessions.user_not_found')]
            }, status: 404
        end

        private

        def resource_params
            params.permit(*params_for_resource(:sign_in))
        end
        end
    end
