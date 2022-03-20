class UserHashIdNullFalse < ActiveRecord::Migration[7.0]
  def change
    change_column_null :users, :hash_id, false
  end
end
