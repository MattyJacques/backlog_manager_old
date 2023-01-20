require 'rails_helper'

RSpec.describe Trophy, type: :model do
  let(:platform) { Platform.new(id: 17, name: 'PlayStation 5', igdb_id: 10) }

  it { should belong_to(:trophy_list) }
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
      release = Release.create( date: DateTime.now,
                                game: game,
                                platform: platform,
                                region: :worldwide,
                                psn_communication_id: 'NPWR00190_00',
                                psn_title_id: 'PPSA01284_00')
      trophy_list = TrophyList.create(release: release)

      Trophy.create(trophy_list: trophy_list,
                    psn_id: 1,
                    name: 'The Platinum',
                    detail: 'Earn all other trophies',
                    icon_url: 'trophyicons.com/this_icon',
                    rank: Trophy.ranks[:bronze])

      should validate_uniqueness_of(:psn_id).scoped_to(:trophy_list_id)
    end
  end
end
