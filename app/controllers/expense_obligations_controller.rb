# Controller for registering, updating, and deleting obligations
class ExpenseObligationsController < ApplicationController
	def index
		@expense = current_user.expenses.find(params[:expense_id])
		@obligations = @expense.obligations.includes(:user)
		@user_contributions = @expense.contributions.includes(:user).inject({}) do |user_contributions, contribution|
			user_contributions[contribution.user_id] = contribution
			user_contributions
		end
	end

  def pay
    @obligation = ExpenseObligation.find(params[:id])
    authorize! :pay, @obligation
    @contribution = PayObligation.pay(@obligation)
  end

  private

  def expense_obligation_pay_params
    params.require(:expense_obligation).permit(:user_id)
  end
end
