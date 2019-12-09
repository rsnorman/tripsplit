module Api::MembersHelper
  def owed_members(user, trip)
    trip.members
      .map { |member| [member, user.owes_user(member, trip)] }
      .select { |(member, amount)| member.id != user.id && amount > 0 }
  end
end
