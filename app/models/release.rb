# Model responsible for handling Release records
# id: integer
# date: string
# game_id: integer
# platform_id: integer
# psn_communication_id: string
# psn_title_id: string
class Release < ApplicationRecord
  belongs_to :game
  belongs_to :platform

  enum region: { europe: 1, north_america: 2, australia: 3, new_zealand: 4,
    japan: 5, china: 6, asia: 7, worldwide: 8, korea: 9, brazil: 10 }, _prefix: true

  validates :date, presence: true
  validates :psn_communication_id, format: { with: /\ANPWR[0-9]{5}_00\z/, allow_nil: true },
    uniqueness: { scope: [:game_id, :platform_id, :region], allow_nil: true, case_sensitive: false }
  validates :psn_title_id, uniqueness: { case_sensitive: false, allow_nil: true }
  validates :region, presence: true

  # Create a Release record, converting the unix timestamp to a Date
  def self.convert_timestamp_and_create(game, platform, region, unix_timestamp)
    Release.create!(game: game, platform: platform, region: region, date: unix_to_date(unix_timestamp))
  end

  private

  def self.unix_to_date(timestamp)
    time = Time.at(timestamp).utc
    Date.new(time.year, time.month, time.day)
  end
end
