class CreateFunnelSteps < ActiveRecord::Migration[7.0]
  def change
    create_table :funnel_steps do |t|
      t.string :event_name, null: false
      t.references :funnel, null: false, foreign_key: true
      t.integer :order

      t.timestamps
    end
  end
end
