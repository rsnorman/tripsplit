json.(obligation, :id, :expense_id, :is_annulled)
json.amount to_money(obligation.amount)

contribution = nil if local_assigns[:contribution].nil?
if contribution
  json.is_paid true
  json.label 'Paid'
elsif obligation.user_id == obligation.expense.purchaser_id
  json.label 'Purchased'
  json.is_paid true
elsif obligation.is_annulled
  json.label 'Removed'
  json.is_paid false
else
  json.label 'Unpaid'
  json.is_paid false
end

json.user do
  json.partial! 'api/v1/users/user', user: obligation.user
end

include_expense_obligations = false if local_assigns[:include_expense_obligations].nil?
json.expense do
  json.partial! 'api/v1/expenses/expense', expense: obligation.expense, include_obligations: include_expense_obligations
end

json.actions do
  json.show(url: api_link(api_v1_expense_obligation_path(obligation)), method: 'GET') if can?(:read, obligation)
  json.destroy(url: api_link(api_v1_expense_obligation_path(obligation)), method: 'DELETE') if can?(:destroy, obligation) && can_annul?(obligation, contribution)
  json.activate(url: api_link(activate_api_v1_expense_obligation_path(obligation)), method: 'POST') if can?(:activate, obligation) && can_activate?(obligation)
  json.pay(url: api_link(pay_api_v1_expense_obligation_path(obligation)), method: 'POST') if can?(:pay, obligation) && can_pay?(obligation, contribution)
  json.unpay(url: api_link(unpay_api_v1_expense_obligation_path(obligation)), method: 'DELETE') if can?(:unpay, obligation) && can_unpay?(obligation, contribution)
end
