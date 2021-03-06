json.partial! 'api/v1/users/user', user: member

json.total_purchased_amount to_money(member.purchases.where(trip: trip).sum(:cost))
json.total_paid_back_amount to_money(trip.total_paid_back_from(member))
json.total_contributed_amount to_money(trip.total_contributed_from(member))
json.owes_current_user to_money(member.owes_user(current_user, trip))

json.actions do
  json.view_payments(url: api_link(api_v1_user_payments_path(member, trip_id: trip.id)), method: 'GET') if can?(:view_payments, trip)
  json.update(url: api_link(api_v1_trip_member_path(member, trip_id: trip.id)), method: 'PATCH') if can?(:update_member, trip) && member.unregistered?
  json.delete(url: api_link(api_v1_trip_member_path(member, trip_id: trip.id)), method: 'DELETE') if can?(:delete_member, trip) && member.id != trip.organizer_id
end
