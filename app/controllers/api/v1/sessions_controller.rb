class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  respond_to :json

  def render_create_success
    @user = @resource
  end
end
