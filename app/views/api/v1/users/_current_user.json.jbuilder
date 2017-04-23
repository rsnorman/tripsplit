json.(@user, :id, :name, :email)

cache_json_image(json, @user, :picture)

json.total_trips @user.trips.count
json.total_purchased @user.total_purchases_cost
json.total_paid @user.total_contributions_cost
json.refresh_at 7.days.from_now
