running_total = 0

json.array! @payments do |payment|
  json.(payment, :name, :amount, :picture, :expense_type, :payment_type, :total)

  amount = payment.recipient == current_user ? payment.amount : payment.amount * -1
  running_total += amount

  json.running_total running_total
  json.amount amount

  json.recipient do
    json.partial! 'api/v1/users/user', user: payment.recipient
  end

  json.payer do
    json.partial! 'api/v1/users/user', user: payment.payer
  end
end
