class AddNotNullConstraintToEvents < ActiveRecord::Migration[6.1]
  def change
    change_column_null :events, :project_id, false
  end
end
