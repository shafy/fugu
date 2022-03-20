# frozen_string_literal: true

namespace :fugu do
  namespace :migration do
    desc "Generate hash_id for Users who don't have one (< schema version 20220314175006)"
    # run automatically by 20220314175006 migration code
    task generate_hash_ids: :environment do
      User.find_each do |user|
        user.add_hash_id if user.hash_id.blank?
        user.save
      end
    end
  end
end
