json.partial! 'api/v1/users/user', user: member

json.purchases do
  json.array! member.purchases.where(trip: trip) do |purchase|
    json.(purchase, :id, :name, :description, :expense_type, :purchaser_id)
    cache_json_image(json, purchase, :picture)
    json.cost to_money(purchase.cost)
  end
end

json.owed_members do
  json.array! owed_members(member, trip) do |(member, amount)|
    json.partial! 'api/v1/users/user', user: member
    json.amount to_money(amount)
  end
end
