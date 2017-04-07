json.array! @obligations do |obligation|
  json.partial! 'obligation', obligation: obligation, contribution: @user_contributions[obligation.user_id]
end
