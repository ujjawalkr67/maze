class HomeController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user!, only: %i[edit update destroy]

  def index
    # Show public posts for everyone + private posts only for the current user
    @posts = Post.includes(:comments, :user, :likes).where("public = ? OR user_id = ?", true, current_user.id).order(created_at: :desc)
    @users = current_user.has_role?(:admin) ? User.left_joins(:roles).where.not(roles: { name: '1' }) : nil
  end

  def create
    @post = current_user.posts.build(post_params) # Associate post with the logged-in user

    if @post.save
      redirect_to home_path, notice: 'Post was successfully created.'
    else
      flash[:alert] = "Error creating post."
      render :index, status: :unprocessable_entity
    end
  end
  def like
    @post = Post.find(params[:id])
    if @post.liked_by?(current_user)
      @post.likes.find_by(user: current_user).destroy
      liked = false
    else
      @post.likes.create(user: current_user)
      liked = true
    end
  
    render json: { liked: liked, likes_count: @post.likes.count }
  end
  def show
    # Ensure users can only view private posts that they own
    if !@post.public && @post.user != current_user
      redirect_to home_path, alert: "You are not authorized to view this post."
    end
    @comments = @post.comments.includes(:user).order(created_at: :desc) # Eager load users
    @comment = @post.comments.build 
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to home_path, notice: 'Post updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @post.destroy
      redirect_to home_path, notice: 'Post deleted successfully.'
    else
      redirect_to home_path, alert: "Failed to delete post."
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :description, :public)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def authorize_user!
    unless @post.user == current_user
      redirect_to home_path, alert: "You are not authorized to perform this action."
    end
  end
end
