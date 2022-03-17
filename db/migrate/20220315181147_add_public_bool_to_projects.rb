class AddPublicBoolToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :public, :boolean, default: false
  end
end
