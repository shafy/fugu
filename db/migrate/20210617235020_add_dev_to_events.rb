class AddDevToEvents < ActiveRecord::Migration[6.1]
  def change
    add_column :events, :staging, :boolean, default: false 
  end
end
