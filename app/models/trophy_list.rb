class TrophyList < ApplicationRecord
  enum region: [:europe, :north_america, :germany, :asia, :china, :japan, :original]

  belongs_to :release
  has_many :trophies, dependent: :destroy
end
