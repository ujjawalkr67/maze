class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    likeable = find_likeable
    likeable.likes.create(user: current_user)
    redirect_to request.referer, notice: "Liked"
  end

  def destroy
    like = Like.find(params[:id])
    like.destroy if like.user == current_user
    redirect_to request.referer, notice: "Unliked"
  end

  private
  def find_likeable
    params.each do |name, value|
      if name.end_with?("_id")
        return name.chomp("_id").classify.constantize.find(value)
      end
    end
  end
  end
  