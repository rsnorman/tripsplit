json.(obligation, :id, :amount, :expense_id)

if contribution
  json.is_paid true
else
  json.is_paid obligation.user_id == obligation.expense.purchaser_id
end

json.user do
  json.partial! 'users/user', user: obligation.user
end

json.expense do
  json.partial! 'expenses/expense', expense: obligation.expense
end

json.actions do
  json.show(url: api_link(expense_obligation_path(obligation)), method: 'GET') if can?(:read, obligation)
  json.pay(url: api_link(pay_expense_obligation_path(obligation)), method: 'POST') if can?(:pay, obligation)
end
