json.array! @members do |member|
  json.partial! 'member', member: member, trip: @trip
end
