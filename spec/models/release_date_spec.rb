require 'rails_helper'

RSpec.describe ReleaseDate, type: :model do
  let(:game) { Game.new(id: 1, name: 'The Last of Us', igdb_id: 7) }
  let(:platform) { Platform.new(id: 17, name: 'PlayStation 5', igdb_id: 10) }

  subject {
    described_class.new(date: DateTime.now,
                        game: game,
                        platform: platform)
  }

  it { should belong_to(:game) }
  it { should belong_to(:platform) }

  context 'when validated' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a date' do
      subject.date = nil
      expect(subject).to_not be_valid
    end
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
