json.partial! 'trip', trip: @trip

json.members do
  json.array! @trip.members do |member|
    json.partial! 'member', member: member, trip: @trip
  end
end
