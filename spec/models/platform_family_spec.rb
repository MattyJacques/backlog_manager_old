require 'rails_helper'

RSpec.describe PlatformFamily, type: :model do
  subject {
    described_class.new(name: 'PlayStation',
                        igdb_id: 9)
  }

  it { should have_many(:platforms) }

  context 'when validated' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without a igdb_id' do
      subject.igdb_id = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid with a string as igdb_id' do
      subject.igdb_id = 'hello'
      expect(subject).to_not be_valid
    end

    it 'is not valid when igdb_id is not unique' do
      subject.save!
  
      expect(PlatformFamily.new(name: 'Xbox', igdb_id: 9)).to_not be_valid
    end
  end

  describe '.find_or_create' do
    it 'creates platform_family if none found' do
      result = described_class.find_or_create(9, 'The Last of Us')

      expect(result.name).to eq('The Last of Us')
      expect(result.igdb_id).to eq(9)
    end

    it 'returns platform_family if one is found' do
      subject.save!

      result = described_class.find_or_create(9, 'The Last of Us')

      expect(result.name).to eq(subject.name)
      expect(result.igdb_id).to eq(subject.igdb_id)
    end

    it 'returns nil if igdb_id is missing' do
      result = described_class.find_or_create(nil, 'The Last of Us')
      expect(result).to be_nil
    end

    it 'returns nil if name is missing' do
      result = described_class.find_or_create(9, nil)
      expect(result).to be_nil
    end
  end
end
