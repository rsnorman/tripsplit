# Controller for registering, updating, and deleting expenses
class ExpensesController < ApplicationController
	respond_to :json

  load_and_authorize_resource :trip, through: :current_user, only: [:index, :create]
  load_and_authorize_resource through: :trip, only: :create
  load_and_authorize_resource except: [:index, :create]

	def index
		@expenses = @trip.expenses.order(created_at: :desc)
	end

	def create
		@expense = @trip.expenses.build(expense_params)
		@expense.save
	end

	def update
		@expense.update_attributes(expense_params)
	end

	def destroy
		@expense.destroy
	end

	private

	def expense_params
		params.require(:expense).permit(:purchaser_id, :cost, :expense_type, :name, :description, :picture).tap do |p|
      if cannot?(:create_member_expense, @expense) || p[:purchaser_id].nil?
        p[:purchaser_id] = current_user.id
      end
		end
	end
end
