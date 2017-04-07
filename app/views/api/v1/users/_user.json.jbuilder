json.cache! ['v1', user], expires_in: 10.minutes do
  json.(user, :id, :picture, :email)
  json.name user.name || user.email
end
