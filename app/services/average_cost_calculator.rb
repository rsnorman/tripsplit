class AverageCostCalculator
  def self.calculate(expense)
    new(expense).calculate
  end

  def initialize(expense)
    @expense = expense
  end

  def calculate
    return 0 if obligations.active.count.zero?
    expense.cost / obligations.active.count
  end

  private
  attr_reader :expense

  delegate :obligations, to: :expense
end
