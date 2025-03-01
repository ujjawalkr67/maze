module Admin
    class DashboardController < BaseController
      def index
        @users = User.all
        @posts = Post.all
      end
    end
  end
  