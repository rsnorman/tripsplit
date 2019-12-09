json.(trip, :id, :name, :location, :description, :total_members)

cache_json_image(json, trip, :picture)

json.total_cost to_money(trip.total_cost)
json.average_cost_per_member to_money(trip.average_cost_per_member)

json.organizer do
  json.partial! 'api/v1/users/user', user: trip.organizer
end
