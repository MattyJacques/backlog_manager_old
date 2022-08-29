class Trophy < ApplicationRecord
  enum rank: [:bronze, :silver, :gold, :platinum]

  belongs_to :game

  validates :psn_id, presence: true, uniqueness: { scope: :game_id }
  validates :name, presence: true
  validates :detail, presence: true
  validates :icon_url, presence: true
  validates :rank, presence: true
end
