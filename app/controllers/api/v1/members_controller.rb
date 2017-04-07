# Controller for retrieving trip members
class Api::V1::MembersController < Api::ApiController
  load_and_authorize_resource :trip, through: :current_user

  def index
    @members = @trip.members
  end
end
