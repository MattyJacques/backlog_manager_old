# Model responsible for handling Platform records
# id: integer
# name: string
# igdb_id: integer
# platform_family_id: integer
class Platform < ApplicationRecord
  has_and_belongs_to_many :games
  belongs_to :platform_family, optional: true

  validates :name, presence: true, uniqueness: true
  validates :igdb_id, presence: true, numericality: { only_integer: true }, uniqueness: true
end
