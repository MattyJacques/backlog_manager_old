# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Client::Games do
  describe '.search', :vcr do
    context 'when arguments are valid' do
      let(:ps4) { build(:ps4) }

      it 'returns the search results of the name' do
        results = described_class.search('The Last of Us')

        expect(results.count).to be_positive
        results.each do |result|
          expect(result['name']).to include('The Last of Us')
        end
      end

      it 'returns the search results that match name and platform' do
        results = described_class.search('The Last of Us', [ps4])

        expect(results.count).to be_positive
        results.each do |result|
          expect(result['name']).to include('The Last of Us')
          expect(result['platforms'].pluck('id')).to include(ps4.igdb_id)
        end
      end
    end

    context 'when arugments are invalid' do
      before do
        allow(described_class).to receive(:post)
      end

      it 'handles blank game name' do
        expect(described_class).not_to receive(:post)

        expect { described_class.search('') }.to raise_error(RuntimeError, 'Search query should not be blank')
      end

      it 'handles game name of nil' do
        expect(described_class).not_to receive(:post)

        expect { described_class.search(nil) }.to raise_error(RuntimeError, 'Search query should not be blank')
      end
    end
  end

  describe '.get_by_name', :vcr do
    context 'when arguments are valid' do
      it 'gets the correct game' do
        response = described_class.get_by_name('The Last of Us')

        expect(response['name']).to eq('The Last of Us')
      end
    end

    context 'when arguments are invalid' do
      it 'handles name being nil' do
        expect(described_class).not_to receive(:post)

        expect { described_class.get_by_name('') }.to raise_error(RuntimeError, 'Game name should not be blank')
      end
    end
  end

  describe '.get_by_id', :vcr do
    context 'when arguments are valid' do
      it 'gets the correct game' do
        response = described_class.get_by_id('1009')

        expect(response['name']).to eq('The Last of Us')
      end
    end

    context 'when arguments are invalid' do
      it 'handles igdb_id being nil' do
        expect(described_class).not_to receive(:post)

        expect { described_class.get_by_id(nil) }.to raise_error(RuntimeError, 'IGDB ID should not be blank')
      end
    end
  end
end
