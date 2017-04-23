json.data do
  json.partial! 'api/v1/users/current_user', user: @user
end
