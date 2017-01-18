module Overrides
class ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :set_current_user,:authenticate_permission_token
  def new
    super
  end

  def create
    super
  end

  def show
     self.resource = resource_class.confirm_by_token(params[:confirmation_token])
     if resource.status == "inactive"
       redirect_to root_url+'#/inactivated'
     else
      if resource.errors.empty?
        set_flash_message(:notice, :confirmed) if is_navigational_format?
        redirect_to root_url+'#/activated'
      #  sign_in(resource_name, resource)
      #  respond_with_navigational(resource){ redirect_to
      #        after_confirmation_path_for(resource_name, resource) }
     else
       flash[:notice] = "Your account is already confirmed. Please login."
       redirect_to root_url+'#/already-activated'
     end
   end
   end
end
end
