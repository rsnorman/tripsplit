json.(obligation, :id, :expense_id)
json.amount to_money(obligation.amount)

if contribution
  json.is_paid true
  json.label 'Paid'
elsif obligation.user_id == obligation.expense.purchaser_id
  json.label 'Purchased'
  json.is_paid true
else
  json.label 'Unpaid'
  json.is_paid false
end

json.user do
  json.partial! 'api/v1/users/user', user: obligation.user
end

json.expense do
  json.partial! 'api/v1/expenses/expense', expense: obligation.expense
end

json.actions do
  json.show(url: api_link(api_v1_expense_obligation_path(obligation)), method: 'GET') if can?(:read, obligation)
  json.pay(url: api_link(pay_api_v1_expense_obligation_path(obligation)), method: 'POST') if can?(:pay, obligation)
  json.unpay(url: api_link(unpay_api_v1_expense_obligation_path(obligation)), method: 'DELETE') if can?(:unpay, obligation)
end
