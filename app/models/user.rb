class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable
          # :recoverable, :rememberable, :trackable, :validatable,
          # :confirmable, :omniauthable
  include DeviseTokenAuth::Concerns::User

  mount_uploader :picture, UserPictureUploader

  attr_accessor :current_trip

  has_many :organized_trips, class_name: Trip, foreign_key: :organizer_id, dependent: :destroy
  has_many :purchases, class_name: Expense, foreign_key: :purchaser_id, dependent: :destroy
  has_many :memberships, class_name: TripMembership, dependent: :destroy
  has_many :trips, through: :memberships
  has_many :expenses, through: :trips
  has_many :contributions, class_name: ExpenseContribution, dependent: :destroy
  has_many :obligations, class_name: ExpenseObligation, dependent: :destroy
  has_many :friendships, dependent: :destroy
  has_many :friends, through: :friendships

  # Calculates the total cost of the expenses paid for by user of all the trips taken
  # return [BigDecimal] total cost of expenses
  def total_purchases_cost
    purchases.to_a.sum(&:cost)
  end

  # Calculates the total cost of the expenses paid for by user of all the trips taken
  # return [BigDecimal] total cost of expenses
  def total_contributions_cost
    contributions.to_a.sum(&:amount)
  end

  # Calculates the total cost of the expenses paid for by the user for a single trip
  # retun [BigDecimal] total cost of expenses for trip
  def total_trip_purchases_cost(trip)
    purchases.select { |x| x.trip_id == trip.id }.sum(&:cost)
  end

  # Returns the key assigned to the user
  # @return [String, Int] key of the user
  def key
    self.id
  end

  # Adds an expense to the trip from the user
  # @param [Trip] trip that expense is being added to
  # @param [Hash] attributes for purchase/expense
  # @todo Write tests for this method
  def purchase(trip, attributes = {})
    e = Expense.new(attributes)
    e.purchaser = self
    e.trip = trip
    e.save
    e
  end

  # Adds an obligation for a user for an expense
  # @param [Expense] expense that user has an obligation to pay
  # @param [BigDecimal] amount the user is obligated to the bill
  def add_obligation(expense, name, amount)
    return unless expense.obligations.where(user_id: self.id).empty?

    obligation = ExpenseObligation.new(name: name, amount: amount)
    obligation.user = self
    obligation.expense = expense
    obligation.save!
    obligation
  end

  # Adds a contribution for a user for an expense
  # @param [Expense] expense that user has an obligation to pay
  # @param [BigDecimal] amount the user is contributing to the bill
  def add_contribution(expense, amount)
    contribution = ExpenseContribution.new(amount: amount)
    contribution.user = self
    contribution.expense = expense
    contribution.save!
    contribution
  end

  # Returns the amount owed from a member on a trip to the user
  # @param [User] member that owes money
  # @return [BigDecimal] amount the user is owed from trip member
  def amount_owed_from(member, trip = nil)
    purchases_ids = trip ? self.purchases.where(trip_id: trip.id).collect(&:id) : self.purchases.collect(&:id)
    member_purchases_ids = trip ? member.purchases.where(trip_id: trip.id).collect(&:id) : member.purchases.collect(&:id)
    [(member.obligations.where(expense_id: purchases_ids).sum(:amount) - member.contributions.where(expense_id: purchases_ids).sum(:amount)) - (self.obligations.where(expense_id: member_purchases_ids).sum(:amount) - self.contributions.where(expense_id: member_purchases_ids).sum(:amount)), 0].max
  end

  # Returns the amount due to a member on a trip from the user
  # @param [User] member that is due money
  # @return [BigDecimal] amount the member is due from user
  def amount_due_to(member, trip = nil)
    purchases_ids = trip ? self.purchases.where(trip_id: trip.id).collect(&:id) : self.purchases.collect(&:id)
    member_purchases_ids = trip ? member.purchases.where(trip_id: trip.id).collect(&:id) : member.purchases.collect(&:id)
    [(self.obligations.where(expense_id: member_purchases_ids).sum(:amount) - self.contributions.where(expense_id: member_purchases_ids).sum(:amount)) - (member.obligations.where(expense_id: purchases_ids).sum(:amount) - member.contributions.where(expense_id: purchases_ids).sum(:amount)), 0].max
  end

  def owes_user(user, trip = nil)
    user_purchase_ids = user.purchases.pluck(:id)
    owe_amount = trip.obligations.where(user: self, expense_id: user_purchase_ids).sum(:amount)

    purchase_ids = purchases.pluck(:id)
    due_amount = trip.obligations.where(user: user, expense_id: purchase_ids).sum(:amount)

    paid_out_amount = trip.contributions.where(user: self, expense_id: user_purchase_ids).sum(:amount)

    paid_in_amount = trip.contributions.where(user: user, expense_id: purchase_ids).sum(:amount)

    owe_amount + paid_in_amount - due_amount - paid_out_amount
  end

  def serializable_hash(*args)
    args[0] = (args[0] || {}).merge(:except => [:password] )
    user_hash = super

    user_hash[:total_trips] = trips.count
    user_hash[:total_purchased] = total_purchases_cost
    user_hash[:total_paid] = total_contributions_cost

    user_hash
  end
end
