class UsersController < ApplicationController
  # before_filter :authenticate_user!, only: [:create, :upvote]
  # respond_to :json

  def index
    render json: User.all
  end

  def show
    # render json: User.find(params[:id])
  end

 def connected_accounts
   providers = UserLogin.select(:provider).where(user_id: current_user.id).map(&:provider)
   render json:  providers
 end

end
