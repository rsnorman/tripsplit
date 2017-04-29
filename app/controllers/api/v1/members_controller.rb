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
    authorize! :update_member, @trip
    @member.update(member_params)
  end

  def destroy
    @member = @trip.members.find(params[:id])
    @membership = @trip.memberships.find_by(user_id: @member.id)
    authorize! :delete_member, @trip
    @membership.destroy
  end

  private

  def set_member
    @member ||= User.find_by(email: member_params[:email]) || User.create(member_params)
  end

  def member_params
    params.require(:member).permit(:name, :email, :picture)
  end
end
