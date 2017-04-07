# Controller for registering, updating, and deleting expenses
class PaymentsController < ApplicationController
	before_action :get_payment_user, only: :index
  before_action :get_trip, only: :index

	def index
    @payments = get_payments
	end

  private

  def get_payment_user
    @payment_user = User.find(params[:user_id])
  end

  def get_trip
    fail ArgumentError, "Trip ID must be passed in params" unless params[:trip_id]
    @trip = current_user.trips.find(params[:trip_id])
  end

  def get_payments
    PeerToPeerPayments.new(user: current_user, peer: @payment_user, trip: @trip).all
  end
end
