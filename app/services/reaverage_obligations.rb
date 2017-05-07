class ReaverageObligations
  def self.reaverage(expense)
    new(expense).reaverage
  end

  def initialize(expense, average_cost_calculator: AverageCostCalculator)
    @expense = expense
    @average_cost_calculator = average_cost_calculator
  end

  def reaverage
    Expense.transaction do
      obligations.active.update_all(amount: average_cost)
      contributions.update_all(amount: average_cost)
    end
  end

  private
  attr_reader :expense

  delegate :obligations, to: :expense
  delegate :contributions, to: :expense

  def average_cost
    @average_cost ||= @average_cost_calculator.calculate(expense)
  end
end
