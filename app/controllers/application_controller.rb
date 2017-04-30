class ApplicationController < ActionController::Base
  before_action :redirect_to_https
  before_action :authenticate_user!, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def redirect_to_https
    redirect_to protocol: 'https://' unless (request.ssl? || request.local?)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation, :current_password])
  end
end
