module Api::ExpenseObligationsHelper
  def order_expense_obligations(obligations, purchaser: purchaser)
    obligations.sort do |a, b|
      (purchaser.id == a.user_id ? 0 : 1) <=> (purchaser.id == b.user_id ? 0 : 1)
    end
  end
end
