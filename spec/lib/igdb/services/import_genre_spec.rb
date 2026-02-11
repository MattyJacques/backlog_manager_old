# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::Services::ImportGenre do
  describe '.import' do
    let(:genre) { build(:genre, igdb_id:) }
    let(:igdb_id) { 11 }
    let(:genre_response) do
      {
        'id' => igdb_id,
        'name' => genre.name,
        'slug' => genre.slug
      }
    end

    before do
      allow(Genre).to receive(:find_or_initialize_by).with(igdb_id: genre.igdb_id).and_return(genre)
      allow(IGDB::Client::Genres).to receive(:get_by_id).with(igdb_id).and_return(genre_response)
    end

    it 'imports the genre from IGDB with the given ID' do
      expect(genre).to receive(:update!).with(name: genre.name, slug: genre.slug)

      described_class.import(igdb_id)
    end
  end
end
