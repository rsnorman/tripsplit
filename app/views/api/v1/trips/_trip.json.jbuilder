json.(trip, :id, :name, :location, :picture, :description, :total_cost, :average_cost_per_member, :total_members)

json.organizer do
  json.partial! 'api/v1/users/user', user: trip.organizer
end

json.actions do
  json.show(url: api_link(api_v1_trip_path(trip)), method: 'GET')
  json.update(url: api_link(api_v1_trip_path(trip)), method: 'PATCH') if can?(:update, trip)
  json.delete(url: api_link(api_v1_trip_path(trip)), method: 'DELETE') if can?(:destroy, trip)
  json.create_expense(url: api_link(api_v1_trip_expenses_path(trip)), method: 'POST') if can?(:add_expense, trip)
  json.view_expenses(url: api_link(api_v1_trip_expenses_path(trip)), method: 'GET') if can?(:view_expenses, trip)
  json.view_members(url: api_link(api_v1_trip_members_path(trip)), method: 'GET') if can?(:view_members, trip)
  json.add_members(url: api_link(join_api_v1_trip_path(trip)), method: 'GET') if can?(:add_members, trip)
end