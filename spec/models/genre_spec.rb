require 'rails_helper'

RSpec.describe Genre, type: :model do
  subject {
    described_class.new(name: 'Adventure',
                        igdb_id: 8)
  }

  it { should have_and_belong_to_many(:games) }

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
  
      expect(Genre.new(name: 'Action', igdb_id: 8)).to_not be_valid
    end
  end
end
