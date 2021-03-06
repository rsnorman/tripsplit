json.(expense, :id, :name, :description, :expense_type, :purchaser_id)

cache_json_image(json, expense, :picture)

json.cost to_money(expense.cost)
json.average_cost to_money(expense.average_cost)

json.purchaser do
  json.partial! 'api/v1/users/user', user: expense.purchaser
end

json.trip do
  json.partial! 'api/v1/trips/trip', trip: expense.trip
end

include_obligations = false if local_assigns[:include_obligations].nil?
if include_obligations
  json.obligations do
    json.array! order_expense_obligations(expense.obligations, purchaser: expense.purchaser) do |obligation|
      json.partial! 'api/v1/expense_obligations/obligation', obligation: obligation, contribution: expense.contributions.detect { |c| c.user_id == obligation.user_id }
    end
  end
end

json.actions do
  json.show(url: api_link(api_v1_trip_expense_path(expense.trip, expense)), method: 'GET') if can?(:read, expense)
  json.update(url: api_link(api_v1_trip_expense_path(expense.trip, expense)), method: 'PATCH') if can?(:update, expense)
  json.delete(url: api_link(api_v1_trip_expense_path(expense.trip, expense)), method: 'DELETE') if can?(:destroy, expense)
  json.view_obligations(url: api_link(api_v1_expense_expense_obligations_path(expense)), method: 'GET') if can?(:view_obligations, expense)
end
