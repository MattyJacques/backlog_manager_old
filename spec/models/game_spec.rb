require 'rails_helper'

RSpec.describe Game, type: :model do
  subject {
    described_class.new(name: 'The Last of Us',
                        igdb_id: 7)
  }

  it { should have_and_belong_to_many(:genres) }
  it { should have_and_belong_to_many(:platforms) }
  it { should have_many(:release_dates).dependent(:destroy) }

  context 'when validating everything' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end
  end

  context 'when validating presence' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:igdb_id) }
  end

  context 'when validating numericality' do
    it { should validate_numericality_of(:igdb_id) }
    it { should validate_numericality_of(:how_long_to_beat_id).allow_nil }
  end

  context 'when validating uniqueness' do
    it { should validate_uniqueness_of(:igdb_id) }
  end
end
