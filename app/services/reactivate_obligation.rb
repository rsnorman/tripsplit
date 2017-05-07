class ReactivateObligation
  def self.activate(obligation)
    new(obligation).activate
  end

  def initialize(obligation, reaverage_obligations_service: ReaverageObligations)
    @obligation = obligation
    @reaverage_obligations_service = reaverage_obligations_service
  end

  def activate
    return false unless can_activate?
    ExpenseObligation.transaction do
      obligation.update(is_annulled: false)
      @reaverage_obligations_service.reaverage(expense)
    end
  end

  private

  attr_reader :obligation

  def can_activate?
    obligation.is_annulled
  end

  delegate :expense, to: :obligation
  delegate :user, to: :obligation
end
