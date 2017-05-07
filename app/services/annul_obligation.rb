class AnnulObligation
  def self.annul(obligation)
    new(obligation).annul
  end

  def initialize(obligation, reaverage_obligations_service: ReaverageObligations)
    @obligation = obligation
    @reaverage_obligations_service = reaverage_obligations_service
  end

  def annul
    return false unless can_annul?
    ExpenseObligation.transaction do
      obligation.update(is_annulled: true, amount: 0)
      @reaverage_obligations_service.reaverage(expense)
    end
  end

  private

  attr_reader :obligation

  def can_annul?
    ExpenseContribution.where(user: user, expense: expense).none?
  end

  delegate :expense, to: :obligation
  delegate :user, to: :obligation
end
