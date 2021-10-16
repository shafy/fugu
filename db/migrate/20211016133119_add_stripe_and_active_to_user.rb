class AddStripeAndActiveToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :users, :status, :integer, default: 0, null: false
  end
end
