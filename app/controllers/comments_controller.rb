class CommentsController < ApplicationController
    before_action :set_post
  
    def create
      @comment = @post.comments.build(comment_params)
      if @comment.save
        puts "Comment successfully!"
        redirect_to request.referer, notice: "Comment created"
      else
        puts "Failed: #{@comment.errors.full_messages}" 
        redirect_to request.referer, alert: "Comment"
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
  