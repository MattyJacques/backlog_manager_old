require 'rails_helper'

RSpec.describe Import::IGDB::Games do
  describe '.search', :vcr do
    context 'when arguments are valid' do
      it 'returns the search results of the name' do
        results = described_class.search('The Last of Us')

        expect(results.count).to be_positive
        results.each do |result|
          expect(result.name).to include('The Last of Us')
        end
      end
    end

    context 'when arugments are invalid' do
      before(:each) do
        allow(Import::IGDB::Client).to receive(:post)
      end

      it 'handles blank game name' do
        results = described_class.search('')
        
        expect(results).to be_nil
        expect(Import::IGDB::Client).not_to have_received(:post)
      end

      it 'handles game name of nil' do
        results = described_class.search(nil)
        
        expect(results).to be_nil
        expect(Import::IGDB::Client).not_to have_received(:post)
      end
    end
  end

  describe '.import_by_id', :vcr do
    context 'when arguments are valid' do
      it 'imports the correct game' do
        result = nil
        expect {
          result = described_class.import_by_id('1009')
        }.to change(Game, :count).by(1)
          .and change(Genre, :count).by(2)
          .and change(Platform, :count).by(1)
          .and change(PlatformFamily, :count).by(1)
          .and change(Release, :count).by(2)

        expect(result.name).to eq('The Last of Us')
        expect(result.igdb_id).to eq(1009)
        expect(result.genres[0].name).to eq('Shooter')
        expect(result.genres[1].name).to eq('Adventure')
        expect(result.platforms[0].name).to eq('PlayStation 3')
        expect(result.platforms[0].platform_family.name).to eq('PlayStation')
        expect(result.releases[0].date).to eq(Date.new(2013, 6, 14))
        expect(result.releases[1].date).to eq(Date.new(2013, 6, 14))
      end
    end

    context 'when arguments are invalid' do
      before(:each) do
        allow(Import::IGDB::Client).to receive(:post)
      end

      it 'handles igdb_id being nil' do
        results = described_class.import_by_id(nil)
        
        expect(results).to be_nil
        expect(Import::IGDB::Client).not_to have_received(:post)
      end
    end    
  end

  describe '.import_by_name', :vcr do
    context 'when arguments are valid' do
      it 'imports the correct game' do
        result = nil
        expect {
          result = described_class.import_by_name('The Last of Us')
        }.to change(Game, :count).by(1)
          .and change(Genre, :count).by(2)
          .and change(Platform, :count).by(1)
          .and change(PlatformFamily, :count).by(1)
          .and change(Release, :count).by(2)

        expect(result.name).to eq('The Last of Us')
        expect(result.igdb_id).to eq(1009)
        expect(result.genres[0].name).to eq('Shooter')
        expect(result.genres[1].name).to eq('Adventure')
        expect(result.platforms[0].name).to eq('PlayStation 3')
        expect(result.platforms[0].platform_family.name).to eq('PlayStation')
        expect(result.releases[0].date).to eq(Date.new(2013, 6, 14))
        expect(result.releases[1].date).to eq(Date.new(2013, 6, 14))
      end
    end

    context 'when arguments are invalid' do
      before(:each) do
        allow(Import::IGDB::Client).to receive(:post)
      end

      it 'handles igdb_id being nil' do
        results = described_class.import_by_name(nil)
        
        expect(results).to be_nil
        expect(Import::IGDB::Client).not_to have_received(:post)
      end
    end    
  end
end