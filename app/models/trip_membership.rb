class TripMembership < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user

  validates_uniqueness_of :user_id, scope: :trip_id

  after_create :add_obligations

  def add_obligations
    self.trip.expenses.each do |e|
      user.add_obligation(e, ExpenseObligation::DEFAULT_OBLIGATION_TYPE, e.cost / self.trip.members.size)
      e.reaverage_obligations
    end
  end

  after_destroy :remove_obligations

  def remove_obligations
    user.obligations.where(expense_id: self.trip.expenses.collect(&:id)).destroy_all
    self.trip.expenses.each do |e|
      e.reaverage_obligations
    end
  end
end
