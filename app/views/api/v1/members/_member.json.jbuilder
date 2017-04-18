json.partial! 'api/v1/users/user', user: member

json.total_purchased_amount to_money(member.purchases.where(trip: trip).sum(:cost))
json.total_obligated_amount to_money(trip.total_owed_from(member))
json.total_contributed_amount to_money(trip.total_contributed_from(member))
json.owes_current_user to_money(member.owes_user(current_user, trip))

json.actions do
  json.view_payments(url: api_link(api_v1_user_payments_path(member, trip_id: trip.id)), method: 'GET') if can?(:view_payments, trip)
end
