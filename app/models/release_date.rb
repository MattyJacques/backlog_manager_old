# Model responsible for handling ReleaseDate records
# id: integer
# date: string
# game_id: integer
# platform_id: integer
class ReleaseDate < ApplicationRecord
  belongs_to :game
  belongs_to :platform

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
