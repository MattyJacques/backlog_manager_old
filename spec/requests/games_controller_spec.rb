require 'rails_helper'

RSpec.describe 'Games', type: :request do
  let(:valid_game) {{ name: 'The Last of Us', igdb_id: 1009 }}

  describe 'GET /index' do
    context 'when some Game records exist' do
      it 'renders a successful response' do
        Game.create!(valid_game)

        get games_url

        expect(response).to be_successful
      end
    end

    context 'when no Game records exist' do
      it 'renders a successful response' do
        get games_url

        expect(response).to be_successful
      end
    end
  end

  describe 'GET /show' do
    context 'when the Game record exists' do
      it 'renders a successful response' do
        game = Game.create!(valid_game)

        get game_url(game)

        expect(response).to be_successful
      end
    end

    context 'when the Game record does not exist' do
      it 'renders a successful response' do
        get game_url(100)

        expect(response).to redirect_to(games_url)
      end
    end
  end

  describe 'GET /new' do
    context 'when there is no search param' do
      it 'renders a successful response' do
        get new_game_url

        expect(response).to be_successful
      end
    end

    context 'when there is a search param' do
      it 'shows search results' do
        get new_game_url, params: { search: valid_game[:name] }

        expect(response).to be_successful
      end
    end
  end

  describe 'POST /create', :vcr do

    before do
      Rails.cache.clear
    end
    
    it 'imports game from igdb' do
      expect {
        post games_url, params: { igdb_id: 1009 }
      }.to change(Game, :count).by(1)
        .and change(Genre, :count).by(2)
        .and change(Platform, :count).by(1)
        .and change(PlatformFamily, :count).by(1)
        .and change(Release, :count).by(2)

      game = Game.last
      expect(game.name).to eq(valid_game[:name])
      expect(game.igdb_id).to eq(valid_game[:igdb_id])
      expect(game.genres[0].name).to eq('Shooter')
      expect(game.genres[1].name).to eq('Adventure')
      expect(game.platforms[0].name).to eq('PlayStation 3')
      expect(game.platforms[0].platform_family.name).to eq('PlayStation')
      expect(game.releases[0].date).to eq(Date.new(2013, 6, 14))
      expect(game.releases[1].date).to eq(Date.new(2013, 6, 14))

      expect(response).to redirect_to(game_url(game))
    end
  end
end
