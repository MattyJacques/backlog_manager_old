require 'rails_helper'

RSpec.describe Platform, type: :model do
  subject {
    described_class.new(name: 'PlayStation 5',
                        igdb_id: 10,
                        platform_family_id: 101)
  }

  it { should have_and_belong_to_many(:games) }
  it { should belong_to(:platform_family).without_validating_presence }

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
      family = PlatformFamily.create!(name: "PlayStation", igdb_id: 7)
      subject.platform_family = family
      subject.save!
  
      expect(Platform.new(name: 'Xbox One X', igdb_id: 10)).to_not be_valid
    end
  end
end
