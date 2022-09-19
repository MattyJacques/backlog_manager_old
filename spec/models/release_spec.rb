require 'rails_helper'

RSpec.describe Release, type: :model do
  let(:game) { Game.new(id: 1, name: 'The Last of Us', igdb_id: 7) }
  let(:platform) { Platform.new(id: 17, name: 'PlayStation 5', igdb_id: 10) }

  subject {
    described_class.new(date: DateTime.now,
                        game: game,
                        platform: platform,
                        region: :worldwide,
                        psn_communication_id: 'NPWR00190_00',
                        psn_title_id: 'PPSA01284_00')
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it { should belong_to(:game) }
  it { should belong_to(:platform) }

  it { should define_enum_for(:region).with_values(
    { europe: 1, north_america: 2, australia: 3, new_zealand: 4, japan: 5, china: 6, asia: 7, worldwide: 8, korea: 9,
      brazil: 10 }).with_prefix }

  context 'when validating presence' do
    it { should validate_presence_of(:date) }
  end

  context 'when validating uniqueness' do
    it { should validate_uniqueness_of(:psn_communication_id).scoped_to(:game_id, :platform_id, :region)
      .allow_nil.case_insensitive }
    it { should validate_uniqueness_of(:psn_title_id).allow_nil.case_insensitive }
  end

  context 'when validating format' do
    it { should allow_values('NPWR00160_00', 'NPWR22792_00').for(:psn_communication_id) }
    it { should_not allow_values('7', '00160_00').for(:psn_communication_id) }
  end

  describe '.convert_timestamp_and_create' do
    it 'converts unix timestamp to DateTime' do
      game.save!
      platform.save!

      result = described_class.convert_timestamp_and_create(game, platform, 1, 1652187979)

      expect(result.game).to eq(game)
      expect(result.platform).to eq(platform)
      expect(result.date).to eq(Date.new(2022, 05, 10))
      expect(result.region_europe?).to be_truthy
    end
  end
end
