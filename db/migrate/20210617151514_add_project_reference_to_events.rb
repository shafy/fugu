class AddProjectReferenceToEvents < ActiveRecord::Migration[6.1]
  def change
    add_reference :events, :project, index: true, foreign_key: true
  end
end
