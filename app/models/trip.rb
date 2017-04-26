class Trip < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper

  mount_uploader :picture, TripPictureUploader

  belongs_to :organizer, class_name: User
  has_many :memberships, class_name: TripMembership, dependent: :destroy
  has_many :members, through: :memberships, source: :user
  has_many :expenses, dependent: :destroy
  has_many :obligations, through: :expenses
  has_many :contributions, through: :expenses

  after_create :add_organizer_as_member
  before_create :set_slug

  validates :name, presence: true
  validates :location, presence: true

  # Adds the organizer as a member of the trip
  def add_organizer_as_member
    add_member(organizer)
  end

  # Adds a new member to a trip
  # @param [User] member to be added to trip
  def add_member(member)
    tm = TripMembership.new
    tm.trip = self
    tm.user = member
    tm.save

    tm
  end

  # Adds up all the expenses of the trip and returns the total cost
  # @return [BigDecimal] total cost of trip
  def total_cost
    @total_cost ||= expenses.sum(:cost)
  end

  # Adds up all the expenses and averages them per member
  # @return [BigDecimal] average cost per member of trip
  def average_cost_per_member
    return 0 if memberships.empty?
    total_cost / memberships.size
  end

  # Calculates how much is owed to a member of the trip
  # @param [User] member of the trip
  # @return [BigDecimal] amount owed to the member
  # @note Will return negative if member owes money
  def total_due_to(member)
    [total_contributed_from(member) - total_obligated_from(member), 0].max
  end

  # Calculates how much a member of the trip owes
  # @param [User] member of the trip
  # @return [BigDecimal] amount member owes
  # @note Will return negative if member is owed money
  def total_owed_from(member)
    [total_obligated_from(member) - total_contributed_from(member), 0].max
  end

  # Sums up the total amount the member has paid for on the trip
  # @param [User] member that has contributed
  # @return [BigDecimal] total amount of contributions
  def total_contributed_from(member)
    contributed_total = member.purchases.where(trip_id: self.id).sum(:cost)
    contributed_total += member.contributions.where(["expense_id IN (:expense_ids)", {expense_ids: expenses.collect(&:id)}]).sum(:amount)
    contributed_total -= contributions.where(["expense_id IN (:expense_ids)", {expense_ids: member.purchases.collect(&:id)}]).sum(:amount)
    contributed_total
  end

  # Sums up the total amount the member is obligated for on the trip
  # @param [User] member that has obligations
  # @return [BigDecimal] total amount of obligations
  def total_obligated_from(member)
    member.obligations.where(expense: expenses).sum(:amount)
  end

  # Gets the total number of members for the trip
  def total_members
    members.count
  end

  private

  def set_slug
    self.slug = "#{CGI.escape(name[0..20])}-#{SecureRandom.hex(5)}"
  end
end
