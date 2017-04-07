class PayObligation
  def self.pay(obligation)
    new(obligation).pay
  end

  def initialize(obligation)
    @obligation = obligation
  end

  def pay
    ExpenseContribution.create(expense: obligation.expense,
                               amount: obligation.amount,
                               user: obligation.user)
  end

  private

  attr_reader :obligation
end
