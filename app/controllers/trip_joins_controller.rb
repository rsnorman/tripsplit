# Controller for registering, updating, and deleting trips
class TripJoinsController < ApplicationController
  def new
    @trip = Trip.find_by!(slug: params[:id])
  end

  def create
    @trip = Trip.find(params[:trip_id])
    if @trip.members.include? current_user
      flash[:notice] = "You have already joined #{@trip.name}"
    else
      @trip.members << current_user
      flash[:notice] = "You successfully joined #{@trip.name}!"
    end

    render action: :show
  end
end
