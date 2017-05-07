class PaymentAmountCalculator
  def self.calculate(payment_object)
    new(payment_object).calculate
  end

  def initialize(payment_object)
    @payment_object = payment_object
  end

  def calculate
    case payment_object.class.to_s
    when Expense.to_s
      payment_object.cost / payment_object.obligations.active.count
    when ExpenseContribution.to_s
      payment_object.amount
    else
      raise "Cannot calculate payment amount for #{payment_object.class}"
    end
  end

  private

  attr_reader :payment_object
end
