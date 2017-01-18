class PostsController < ApplicationController
  # before_action :set_user_by_token
  before_filter :authenticate_user!, only: [:create, :upvote]
  # respond_to :json

  def index
    render json: Post.all
  end

  def create
    render json: Post.create(post_params.merge(user_id: current_user.id))
  end

  def show
    render json: Post.find(params[:id])
  end

  def upvote
    post = Post.find(params[:id])
    post.increment!(:upvotes)

    render json: post
  end

  private
  def post_params
    params.require(:post).permit(:link, :title)
  end
end
