json.(@user, :id, :name, :email, :picture)
json.total_trips @user.trips.count
json.total_purchased @user.total_purchases_cost
json.total_paid @user.total_contributions_cost
