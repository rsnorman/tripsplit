module ApplicationHelper
  def to_money(amount)
    return amount.round.to_s if amount.round == amount
    sprintf('%.2f', amount)
  end

  def owed_members(user, trip)
    trip.members
      .map { |member| [member, member.owes_user(user, trip)] }
      .select { |(member, amount)| member.id != user.id && amount > 0 }
  end

  def credited_members(user, trip)
    trip.members
      .map { |member| [member, user.owes_user(member, trip)] }
      .select { |(member, amount)| member.id != user.id && amount > 0 }
  end
end
