class AddUniqueIndexToApiKey < ActiveRecord::Migration[6.1]
  def change
     add_index :api_keys, :key_value, unique: true
  end
end
