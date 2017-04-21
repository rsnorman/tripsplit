class TransferUserOwnership
  def initialize(owning_user)
    @owning_user = owning_user
  end

  def transfer_to(user)
    Expense.where(purchaser: owning_user).update_all(purchaser_id: user.id)
    TripMembership.where(user: owning_user).update_all(user_id: user.id)
    ExpenseObligation.where(user: owning_user).update_all(user_id: user.id)
    ExpenseContribution.where(user: owning_user).update_all(user_id: user.id)
  end

  private
  attr_reader :owning_user
end
