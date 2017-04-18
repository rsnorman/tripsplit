module ApplicationHelper
  def api_link(path)
    "#{request.base_url}#{path}"
  end

  def to_money(amount)
    return amount.round.to_s if amount.round == amount
    sprintf('%.2f', amount)
  end
end
