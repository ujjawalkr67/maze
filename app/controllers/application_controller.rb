class ApplicationController < ActionController::Base
    before_action :authenticate_user!, unless: :landing_page?
    before_action :configure_permitted_parameters, if: :devise_controller?
  
    def after_sign_out_path_for(_resource_or_scope)
      new_user_session_path # Redirects to sign-in page after logout
    end
  
    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :phone_number])
      devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone_number])
    end
  
    def after_sign_up_path_for(_resource)
      root_path # Redirect to home page after sign-up
    end
  
    private
  
    def landing_page?
      controller_name == 'landing' && action_name == 'index'
    end
  end
  