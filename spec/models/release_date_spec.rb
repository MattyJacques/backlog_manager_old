require 'rails_helper'

RSpec.describe ReleaseDate, type: :model do
  let(:game) { Game.new(id: 1, name: 'The Last of Us', igdb_id: 7) }
  let(:platform) { Platform.new(id: 17, name: 'PlayStation 5', igdb_id: 10) }

  subject {
    described_class.new(date: DateTime.now,
                        game: game,
                        platform: platform,
                        psn_communication_id: 'NPWR00190_00',
                        psn_title_id: 'PPSA01284_00')
  }

  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  it { should belong_to(:game) }
  it { should belong_to(:platform) }

  context 'when validating presence' do
    it { should validate_presence_of(:date) }
  end

  context 'when validating uniqueness' do
    it { should validate_uniqueness_of(:psn_communication_id).scoped_to(:game_id, :platform_id, :region_id)
      .allow_nil.case_insensitive }
    it { should validate_uniqueness_of(:psn_title_id).allow_nil.case_insensitive }
  end

  context 'when validating format' do
    it { should allow_values('NPWR00160_00', 'NPWR22792_00').for(:psn_communication_id) }
    it { should_not allow_values('7', '00160_00').for(:psn_communication_id) }
  end

  describe '.convert_create' do
    it 'converts unix timestamp to DateTime' do
      game.save!
      platform.save!

      result = described_class.convert_create(game, platform, 1652187979)

      expect(result.game).to eq(game)
      expect(result.platform).to eq(platform)
      expect(result.date).to eq(Date.new(2022, 05, 10))
    end
  end
end
