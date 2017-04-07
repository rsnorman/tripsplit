# Controller for registering, updating, and deleting obligations
class Api::V1::ExpenseObligationsController < Api::ApiController
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

  def get_obligation
    current_user.obligations.find(params[:id]) rescue current_user.purchases.find(params[:expense_id]).obligations.find(params[:id])
  end

  def expense_obligation_params
    params.require(:expense_obligation).permit(:amount, :name, :user_id, :is_average)
  end

  def expense_obligation_pay_params
    params.require(:expense_obligation).permit(:user_id)
  end
end
