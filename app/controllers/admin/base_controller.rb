module Admin
    class BaseController < ApplicationController
      before_action :authenticate_user!
      before_action :authorize_admin!
  
      private
  
      def authorize_admin!
        redirect_to root_path, alert: "Access denied!" unless current_user.has_role?(:admin)
      end
    end
  end
  