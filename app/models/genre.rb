# Model responsible for handling Genre records
# id: integer
# name: string
# igdb_id: integer
class Genre < ApplicationRecord
  has_and_belongs_to_many :games
end
