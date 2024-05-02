# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Services::ImportGame do
  describe '.import', :vcr do
    context 'when the game has not already been imported' do
      let(:game) { instance_double(Game, platforms: [platform]) }
      let(:platform) { instance_double(Platform, igdb_id: 48) }
      let(:platform_family) { instance_double(PlatformFamily) }
      let(:genre) { instance_double(Genre) }
      let(:release) { instance_double(Release) }

      before do
        allow(Game).to receive(:exists?).and_return(false)
        allow(Game).to receive(:new).and_return(game)
        allow(Genre).to receive(:find_or_initialize_by).and_return(genre)
        allow(PlatformFamily).to receive(:find_or_initialize_by).and_return(platform_family)
        allow(Platform).to receive(:find_or_initialize_by).and_return(platform)
        allow(Release).to receive(:new).and_return(release)
      end

      context 'when given a platform' do
        it 'imports the game' do
          expect(game).to receive(:releases=).with([release])
          expect(game).to receive(:genres=).with([genre, genre])
          expect(game).to receive(:save!)

          described_class.import('The Last of Us', [platform])
        end
      end
    end

    context 'when the game has already been imported' do
      before do
        allow(Game).to receive(:exists?).and_return(true)
      end

      it 'raises an error when game has already been imported' do
        expect { described_class.import('The Last of Us') }.to raise_error(RuntimeError, 'Game already exists')
      end
    end
  end
end
