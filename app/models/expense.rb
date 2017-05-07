class Expense < ActiveRecord::Base
  mount_uploader :picture, ExpensePictureUploader

  belongs_to :purchaser, class_name: User
  belongs_to :trip

  has_many :contributions, class_name: ExpenseContribution, dependent: :destroy
  has_many :obligations, class_name: ExpenseObligation, dependent: :destroy

  after_create :create_obligations_for_trip_members
  after_update :reaverage_obligations, if: -> { self.cost_was != self.cost }

  # Creates obligations for each trip member so that expense is evenly divided
  def create_obligations_for_trip_members
    trip.members.each do |member|
      member.add_obligation(self, ExpenseObligation::DEFAULT_OBLIGATION_TYPE, average_cost)
    end
  end

  # Reaverages the obligations to make sure the full cost is covered of the expense
  def reaverage_obligations
    ReaverageObligations.reaverage(self)
  end

  # Gets the cost for a member, factoring in obligations
  # @param [User] member that cost is being calculated for
  # @return [BigDecimal] cost for the member
  def cost_for(member)
    obligations.active.select { |x| x.user_id == member.id }.map(&:amount).inject(0, :+)
  end

  # Returns the cost for the purchaser, factoring in contributions
  # @return [BigDecimal] cost for purchaser of expense
  def cost_for_purchaser
    cost - contributions.sum(:amount)
  end

  # Gets the contribution from a member, factoring in contributions
  # @param [User] member that contribution is being calculated for
  # @return [BigDecimal] cost for the member
  def contribution_from(member)
    return cost_for_purchaser if member.id == purchaser_id
    contribution = contributions.detect { |x| x.user_id == member.id }
    contribution ? contribution.amount : 0.0
  end

  # Gets the average cost of expense for all trip members
  # @return [BigDecimal] average cost of expense
  def average_cost
    @average_cost ||= AverageCostCalculator.calculate(self)
  end
end
