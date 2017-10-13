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

  def uploaded_image(url, type:, class_name: nil, alt: nil)
    unless url.blank?
      "<img class=\"#{class_name}\" src=\"#{url}\" alt=\"#{alt}\" />".html_safe
    else
      text = if type == :user
              alt.split(' ').map { |n| n[0,1] }.join()
            elsif type == :purchase
              '$'
            else
              type.to_s[0,1].upcase
            end
      "<div class=\"#{class_name} empty-image #{type}\" title=\"#{alt}\">#{text}</div>".html_safe
    end
  end
end
