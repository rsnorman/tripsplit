class AddIsAnulledToObligations < ActiveRecord::Migration
  def change
    add_column :expense_obligations, :is_annulled, :boolean, default: false
  end
end
