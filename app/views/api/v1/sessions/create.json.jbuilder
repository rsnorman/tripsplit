json.data do
  json.(@user, :id, :picture, :name, :email)

  json.total_trips @user.trips.count
  json.total_purchased @user.total_purchases_cost
  json.total_paid @user.total_contributions_cost
  json.refresh_at 7.days.from_now
end
