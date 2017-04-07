class ExpenseObligation < ActiveRecord::Base
  belongs_to :user
  belongs_to :expense

  validates_presence_of :amount, :user_id
  validates_uniqueness_of :user_id, scope: :expense_id
end
