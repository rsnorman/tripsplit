# Controller for retrieving trip members
class MembersController < ApplicationController
	def index
    @trip = Trip.find(params[:trip_id])
		@members = @trip.members
	end
end
