class Api::ApiController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
end
