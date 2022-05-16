# Controller to handle requests that want to view, import or other actions related to Games
class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def new
    @games = Import::IGDB::Games.search(params[:search])
  end

  def create
    game = Import::IGDB::Games.import(params[:igdb_id])
    if game.present?
      redirect_to(game_path(game))
    end
  end
end
