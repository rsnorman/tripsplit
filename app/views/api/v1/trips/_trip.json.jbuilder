json.(trip, :id, :name, :location, :picture, :description, :total_members)

json.total_cost to_money(trip.total_cost)
json.average_cost_per_member to_money(trip.average_cost_per_member)

json.organizer do
  json.partial! 'api/v1/users/user', user: trip.organizer
end

if can?(:add_member_expenses, trip)
  json.purchasers do
    json.array! trip.members.select { |m| m.id != current_user.id } do |member|
      json.partial! 'api/v1/users/user', user: member
    end
  end
end

json.join_trip_url api_link(join_trip_path(trip.slug)) if trip.slug

json.actions do
  json.show(url: api_link(api_v1_trip_path(trip)), method: 'GET')
  json.update(url: api_link(api_v1_trip_path(trip)), method: 'PATCH') if can?(:update, trip)
  json.delete(url: api_link(api_v1_trip_path(trip)), method: 'DELETE') if can?(:destroy, trip)
  json.create_expense(url: api_link(api_v1_trip_expenses_path(trip)), method: 'POST') if can?(:add_expense, trip)
  json.view_expenses(url: api_link(api_v1_trip_expenses_path(trip)), method: 'GET') if can?(:view_expenses, trip)
  json.create_member(url: api_link(api_v1_trip_members_path(trip)), method: 'POST') if can?(:add_member, trip)
  json.view_members(url: api_link(api_v1_trip_members_path(trip)), method: 'GET') if can?(:view_members, trip)
end
