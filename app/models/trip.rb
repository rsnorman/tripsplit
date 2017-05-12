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

  # Sums up the total amount the member has paid for on the trip
  # @param [User] member that has contributed
  # @return [BigDecimal] total amount of contributions
  def total_contributed_from(member)
    member_purchases = member.purchases.where(trip: self)
    member_purchases.sum(:cost) + total_paid_back_from(member) - contributions.where(["expense_id IN (:expense_ids)", {expense_ids: member_purchases.pluck(:id)}]).sum(:amount)
  end

  # Sums up the total amount the member has paid back on the trip
  # @param [User] member that has paid back
  # @return [BigDecimal] total amount paid back
  def total_paid_back_from(member)
    member.contributions.where(["expense_id IN (:expense_ids)", {expense_ids: expenses.collect(&:id)}]).sum(:amount)
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
