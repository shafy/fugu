class CreateApiKeys < ActiveRecord::Migration[6.1]
  def change
    create_table :api_keys do |t|
      t.string :key_value
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
