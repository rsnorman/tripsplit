json.cache! ['v1', user], expires_in: 10.minutes do
  json.(user, :id, :email)
  json.name user.name || user.email
  cache_json_image(json, user, :picture)
end
