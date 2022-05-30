require 'rails_helper'

RSpec.describe "Genres", type: :request do
  let(:valid_genre) {{ name: 'Adventure', igdb_id: 8 }}

  describe 'GET /index' do
    context 'when some Genre records exist' do
      it 'renders a successful response' do
        Genre.create!(valid_genre)

        get genres_url

        expect(response).to be_successful
      end
    end

    context 'when no Genre records exist' do
      it 'renders a successful response' do
        get genres_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the Genre record exists' do
      it 'renders a successful response' do
        genre = Genre.create!(valid_genre)

        get genre_url(genre)

        expect(response).to be_successful
      end
    end

    context 'when the Genre record does not exist' do
      it 'renders a successful response' do  
        get genre_url(100)
  
        expect(response).to redirect_to(genres_url)
      end
    end
  end
end
