class PeerToPeerPayments
  def initialize(user:, peer:, trip:)
    @user = user
    @peer = peer
    @trip = trip
  end

  def all
    payments.sort { |p1, p2| p1.created_at <=> p2.created_at }
  end

  private

  def payments
    user_payments + peer_payments
  end

  def user_payments
    (user_purchases + user_contributions).map do |payment|
      build_payment_object(payment, to: @user, from: @peer)
    end
  end

  def peer_payments
    (peer_purchases + peer_contributions).map do |payment|
      build_payment_object(payment, to: @peer, from: @user)
    end
  end

  def user_purchases
    @user_purchases ||= begin
      purchases = @user.purchases.where(trip: @trip)
      obligations = @peer.obligations.active.where(expense: purchases)
      obligations.map(&:expense)
    end
  end

  def peer_purchases
    return [] if same_user?
    @peer_purchases ||= begin
      purchases = @peer.purchases.where(trip: @trip)
      obligations = @user.obligations.active.where(expense: purchases)
      obligations.map(&:expense)
    end
  end

  def user_contributions
    @user_contributions ||=
      if same_user?
        @user.contributions
          .where(expenses: {trip_id: @trip.id})
          .includes(expense: :trip)
      else
        @user.contributions.where(expense: peer_purchases)
      end
  end

  def peer_contributions
    return [] if same_user?
    @peer_contributions ||= @peer.contributions.where(expense: user_purchases)
  end

  def build_payment_object(payment, to:, from:)
    PaymentFactory.create(payment, recipient: to,
                                   payer: from,
                                   amount: PaymentAmountCalculator.calculate(payment))
  end

  def total_members
    @total_members ||= @trip.members.count
  end

  def same_user?
    @peer.id == @user.id
  end
end
