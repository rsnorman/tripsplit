json.array! order_expense_obligations(@obligations, purchaser: @expense.purchaser) do |obligation|
  json.partial! 'obligation', obligation: obligation, contribution: @user_contributions[obligation.user_id]
end
