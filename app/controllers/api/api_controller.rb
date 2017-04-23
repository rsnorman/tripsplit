class Api::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  rescue_from CanCan::AccessDenied do
    render status: :unauthorized
  end
end
