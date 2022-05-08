# Model responsible for handling PlatformFamily records
# id: integer
# name: string
# igdb_id: integer
class PlatformFamily < ApplicationRecord
  has_many :platforms

  def self.find_or_create(igdb_id, name)
    return unless igdb_id.present? && name.present?

    PlatformFamily.find_by(igdb_id: igdb_id) ||
      PlatformFamily.create!(igdb_id: igdb_id, name: name)
  end
end
