class AddUniqueIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :funnels, %i[name api_key_id], unique: true
    add_index :projects, %i[name user_id], unique: true
  end
end
