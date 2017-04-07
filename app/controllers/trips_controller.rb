# Controller for registering, updating, and deleting trips
class TripsController < ApplicationController
	def index
		@trips = params[:organized] ? current_user.organized_trips : current_user.trips
	end

	def show
		@trip = current_user.trips.find(params[:id])
	end

  def join
    @trip = current_user.trips.find(params[:id])
    @trip.members << current_user
    redirect_to root_path
  end

	def create
		@trip = current_user.trips.build(trip_params)
    @trip.organizer_id = current_user.id
    @trip.save
	end

	def update
		@trip = current_user.organized_trips.find(params[:id])
		@trip.update_attributes(trip_params)
	end

	def destroy
		@trip = current_user.organized_trips.find(params[:id])
		@trip.destroy
	end

	private

	def trip_params
		params.require(:trip).permit(:name, :location, :description, :picture)
	end
end
