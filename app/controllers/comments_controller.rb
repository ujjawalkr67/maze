class CommentsController < ApplicationController
    before_action :set_post
  
    def create
      @comment = @post.comments.build(comment_params)
      if @comment.save
        puts "Comment saved successfully!"   # Debug message
        redirect_to request.referer, notice: "Comment was successfully created."
      else
        puts "Failed to save comment: #{@comment.errors.full_messages}"  # Debug message
        redirect_to request.referer, alert: "Comment was not created."
      end
    end
    
  
    private
  
    def set_post
      @post = Post.find(params[:id])
    end
  
    def comment_params
      params.require(:comment).permit(:data)
    end
  end
  