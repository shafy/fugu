class CreateFunnels < ActiveRecord::Migration[7.0]
  def change
    create_table :funnels do |t|
      t.string :name, null: false
      t.references :api_key, null: false, foreign_key: true

      t.timestamps
    end
  end
end
