class MoveReferenceToApiKey < ActiveRecord::Migration[6.1]
  def change
    remove_reference :events, :project, index: true, foreign_key: true

    add_reference :events, :api_key, index: true, foreign_key: true, null: false
  end
end
