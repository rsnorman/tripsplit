json.array! @trips do |trip|
  json.partial! 'trip', trip: trip
end
