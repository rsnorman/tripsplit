module Api::ExpenseObligationsHelper
  def order_expense_obligations(obligations, purchaser: purchaser)
    obligations.sort do |a, b|
      (purchaser.id == a.user_id ? 0 : 1) <=> (purchaser.id == b.user_id ? 0 : 1)
    end.sort { |a, b| (a.is_annulled ? 1 : 0) <=> (b.is_annulled ? 1 : 0) }
  end

  def can_annul?(obligation, contribution)
    !obligation.is_annulled && !contribution
  end

  def can_activate?(obligation)
    obligation.is_annulled
  end

  def can_pay?(obligation, contribution)
    !obligation.is_annulled && !contribution
  end

  def can_unpay?(obligation, contribution)
    !obligation.is_annulled && contribution
  end
end
