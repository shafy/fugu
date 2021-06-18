class AddMoreNotNullConstraints < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :name, false
    change_column_null :api_keys, :key_value, false
    change_column_null :projects, :name, false
  end
end
