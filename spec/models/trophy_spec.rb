require 'rails_helper'

RSpec.describe Trophy, type: :model do
  it { should belong_to(:game) }
  it { should define_enum_for(:rank).with_values([:bronze, :silver, :gold, :platinum]) }

  context 'when validating presence' do
    it { should validate_presence_of(:psn_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:detail) }
    it { should validate_presence_of(:icon_url) }
    it { should validate_presence_of(:rank) }
  end

  context 'when validating uniqueness' do
    it 'validates uniqueness of psn_id for each game' do
      game = Game.create(name: 'The Last of Us', igdb_id: 7)
      Trophy.create(game: game,
                    psn_id: 1,
                    name: 'The Platinum',
                    detail: 'Earn all other trophies',
                    icon_url: 'trophyicons.com/this_icon',
                    rank: Trophy.ranks[:bronze])

      should validate_uniqueness_of(:psn_id).scoped_to(:game_id)
    end
  end
end
