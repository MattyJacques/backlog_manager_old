class Trophy < ApplicationRecord
  enum rank: [:bronze, :silver, :gold, :platinum]

  belongs_to :trophy_list

  validates :psn_id, presence: true, uniqueness: { scope: :trophy_list_id }
  validates :name, presence: true
  validates :detail, presence: true
  validates :icon_url, presence: true
  validates :rank, presence: true
end
