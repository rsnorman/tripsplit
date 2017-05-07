# Controller for registering, updating, and deleting obligations
class Api::V1::ExpenseObligationsController < Api::ApiController
  load_and_authorize_resource :expense, through: :current_user, only: :index

  def index
    @obligations = @expense.obligations.includes(:user) # TODO: load and authorize
    @user_contributions = @expense.contributions.includes(:user).inject({}) do |user_contributions, contribution|
      user_contributions[contribution.user_id] = contribution
      user_contributions
    end
  end

  def activate
    @obligation = ExpenseObligation.find(params[:id])
    authorize! :activate, @obligation
    ReactivateObligation.activate(@obligation)
  end

  def destroy
    @obligation = ExpenseObligation.find(params[:id])
    authorize! :destroy, @obligation
    AnnulObligation.annul(@obligation)
  end

  def pay
    @obligation = ExpenseObligation.find(params[:id])
    authorize! :pay, @obligation
    @contribution = PayObligation.pay(@obligation)
  end

  def unpay
    @obligation = ExpenseObligation.find(params[:id])
    authorize! :pay, @obligation
    @contribution = ExpenseContribution.find_by(user: @obligation.user, expense: @obligation.expense)
    @contribution.destroy
  end

  private

  def expense_obligation_params
    params.require(:expense_obligation).permit(:amount, :name, :user_id, :is_average)
  end

  def expense_obligation_pay_params
    params.require(:expense_obligation).permit(:user_id)
  end
end
