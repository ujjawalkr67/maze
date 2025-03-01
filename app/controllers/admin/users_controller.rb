module Admin
  class UsersController < BaseController
    def index
      @users = User.all
    end

    def edit
      @user = User.find(params[:id])
    end
    def show
      @user = User.find(params[:id])
    end    
    def update
      @user = User.find(params[:id])
      if @user.update(user_params)
        redirect_to admin_root_path, notice: "User updated successfully"
      else
        render :edit
      end
    end

    def destroy
      @user = User.find(params[:id])
      @user.destroy
      redirect_to admin_root_path, notice: "User deleted"
    end

    def activate
      @user = User.find(params[:id])
      if @user.update(active: true)
        redirect_to admin_root_path, notice: "User activated successfully!"
      else
        redirect_to admin_root_path, alert: "Failed to activate user."
      end
    end
    
    def deactivate
      @user = User.find(params[:id])
      if @user.update(active: false)
        redirect_to admin_root_path, notice: "User deactivated successfully!"
      else
        redirect_to admin_root_path, alert: "Failed to deactivate user."
      end
    end

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to admin_root_path, notice: "User created successfully"
      else
        flash.now[:alert] = "Please fix the errors below."
        render :new, status: :unprocessable_entity
      end
    end

    private

    def authorize_admin!
      redirect_to home_path, alert: "Access denied!" unless current_user.has_role?(:admin)
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation, :active, role_ids: [])
    end
  end
end
