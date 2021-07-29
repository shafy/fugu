class MoveStagingToApiKey < ActiveRecord::Migration[6.1]
  def change
    remove_column :events, :staging, :boolean, default: false

    add_column :api_keys, :test, :boolean, default: false
  end
end
