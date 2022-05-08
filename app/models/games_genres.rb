# Model responsible for handling Game/Genre join records
# game_id: integer
# genre_id: integer
class GamesGenres < ApplicationRecord
  belongs_to :game
  belongs_to :genre
end
