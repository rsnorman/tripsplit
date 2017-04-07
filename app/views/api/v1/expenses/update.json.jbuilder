json.partial! 'expense', expense: @expense

json.obligations do
  json.array! @expense.obligations do |obligation|
    json.partial! 'api/v1/expense_obligations/obligation', obligation: obligation, contribution: @expense.contributions.detect { |c| c.user_id == obligation.user_id }
  end
end
