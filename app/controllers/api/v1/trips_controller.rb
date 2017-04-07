# Controller for registering, updating, and deleting trips
class Api::V1::TripsController < Api::ApiController
  load_and_authorize_resource through: :current_user

  def index
    @trips = current_user.trips
  end

  def create
    @trip.attributes = trip_params
    @trip.save
  end

  def update
    @trip.update(trip_params)
  end

  def destroy
    @trip.destroy
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :location, :description, :picture).tap do |p|
      p[:organizer_id] = current_user.id
    end
  end
end
