class AddHashIdToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hash_id, :string
    add_index :users, :hash_id, unique: true

    Rake::Task["fugu:migration:generate_hash_ids"].invoke
  end
end
