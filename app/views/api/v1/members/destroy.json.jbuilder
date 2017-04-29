json.partial! 'member', member: @member, trip: @trip
json.trip do
  json.partial! 'api/v1/trips/trip', trip: @trip
end
