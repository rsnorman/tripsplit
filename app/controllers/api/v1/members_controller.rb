# Controller for retrieving trip members
class Api::V1::MembersController < Api::ApiController
  load_and_authorize_resource :trip, through: :current_user

  def index
    @members = @trip.members
  end

  def create
    set_member
    @trip.members << @member
  end

  private

  def set_member
    @member ||= User.find_by(email: member_params[:email]) || User.create(member_params)
  end

  def member_params
    params.require(:member).permit(:name, :email)
  end
end
