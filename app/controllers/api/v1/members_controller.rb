# Controller for retrieving trip members
class Api::V1::MembersController < Api::ApiController
  load_and_authorize_resource :trip, through: :current_user

  def index
    @members = @trip.members
  end

  def create
    set_member
    @trip.add_member(@member)
  end

  def update
    @member = @trip.members.find(params[:id])
    authorize! :update_member, @trip, @member
    @member.update(member_params)
  end

  private

  def set_member
    @member ||= User.find_by(email: member_params[:email]) || User.create(member_params)
  end

  def member_params
    params.require(:member).permit(:name, :email, :picture)
  end
end
