# Model responsible for handling Game records
# id: integer
# name: string
# igdb_id: integer
class Game < ApplicationRecord
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :platforms
  has_many :release_dates, dependent: :destroy

  validates :name, presence: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
