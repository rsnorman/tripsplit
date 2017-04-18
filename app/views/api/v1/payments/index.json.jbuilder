running_total = 0

json.array! @payments do |payment|
  json.(payment, :name, :picture, :expense_type, :payment_type)
  json.total to_money(payment.total)

  amount = payment.recipient == current_user ? payment.amount : payment.amount * -1
  running_total += amount

  json.running_total to_money(running_total)
  json.amount to_money(amount)

  json.recipient do
    json.partial! 'api/v1/users/user', user: payment.recipient
  end

  json.payer do
    json.partial! 'api/v1/users/user', user: payment.payer
  end
end
