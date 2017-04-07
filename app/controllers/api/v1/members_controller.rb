# Controller for retrieving trip members
class Api::V1::MembersController < Api::ApiController
	def index
    @trip = Trip.find(params[:trip_id])
		@members = @trip.members
	end
end
