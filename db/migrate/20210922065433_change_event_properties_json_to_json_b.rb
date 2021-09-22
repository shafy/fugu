class ChangeEventPropertiesJsonToJsonB < ActiveRecord::Migration[6.1]
  def change
    change_column :events, :properties, :jsonb
  end
end
