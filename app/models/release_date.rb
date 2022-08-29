# Model responsible for handling ReleaseDate records
# id: integer
# date: string
# game_id: integer
# platform_id: integer
# psn_communication_id: string
# psn_title_id: string
class ReleaseDate < ApplicationRecord
  belongs_to :game
  belongs_to :platform

  validates :date, presence: true
  validates :psn_communication_id, format: { with: /\ANPWR[0-9]{5}_00\z/, allow_nil: true },
    uniqueness: { scope: [:game_id, :platform_id, :region_id], allow_nil: true, case_sensitive: false }
  validates :psn_title_id, uniqueness: { case_sensitive: false, allow_nil: true }

  # Create a ReleaseDate record, converting the unix timestamp to a Date
  def self.convert_create(game, platform, unix_timestamp)
    ReleaseDate.create!(game: game, platform: platform, date: unix_to_date(unix_timestamp))
  end

  private

  def self.unix_to_date(timestamp)
    time = Time.at(timestamp).utc
    Date.new(time.year, time.month, time.day)
  end
end
