class Api::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken

  skip_before_action :authenticate_user!
end
