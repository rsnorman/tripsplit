# Controller for registering, updating, and deleting trips
class TripsController < ApplicationController
  def join
    @trip = current_user.trips.find(params[:id])
    if @trip.members.include? current_user
      flash[:error] = "You have already join #{@trip.name}"
    else
      @trip.members << current_user
      flash[:flash] = "You successfully joined #{@trip.name}!"
    end
    redirect_to root_path
  end
end
