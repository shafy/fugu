class AddUniqueIndex < ActiveRecord::Migration[7.0]
  def change
    add_index :funnel, %i[name api_key_id], unique: true
    add_index :project, %i[name user_id], unique: true
  end
end
