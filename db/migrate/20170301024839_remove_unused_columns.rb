class RemoveUnusedColumns < ActiveRecord::Migration
  def change
    remove_column :expense_contributions, :is_paid, :boolean

    remove_column :expense_obligations, :is_paid, :boolean
    remove_column :expense_obligations, :is_tip, :boolean
    remove_column :expense_obligations, :is_average, :boolean

    remove_column :expenses, :is_loan, :boolean
    remove_column :expenses, :tip, :decimal, precision: 8, scale: 2, default: 0.0
    remove_column :expenses, :tip_included, :boolean

    # drop_table :friendships

    remove_column :trips, :facebook_event_id, :string
    remove_column :trips, :starts_on, :date
    remove_column :trips, :ends_on, :date
    remove_column :trips, :cover_photo, :string

    remove_column :users, :twitter_access_token, :string
    remove_column :users, :twitter_access_secret, :string
    remove_column :users, :twitter_id, :string
    remove_column :users, :profile_image_url, :string
    remove_column :users, :facebook_access_token, :string
    remove_column :users, :facebook_access_token_expires_at, :datetime
    remove_column :users, :facebook_id, :string
  end
end
