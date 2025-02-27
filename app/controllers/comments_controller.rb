class CommentsController < ApplicationController
  before_action :set_post
  before_action :authenticate_user!  # Ensures user is logged in before commenting

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user  # Assign the logged-in user to the comment

    if @comment.save
      puts "Comment successfully added!"
      redirect_to request.referer, notice: "Comment created"
    else
      puts "Failed: #{@comment.errors.full_messages}" 
      redirect_to request.referer, alert: "Failed to add comment"
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])  # Use `params[:post_id]` instead of `params[:id]`
  end

  def comment_params
    params.require(:comment).permit(:data)
  end
end
