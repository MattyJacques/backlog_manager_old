# Controller responsible for handling Genre actions
class GenresController < ApplicationController
  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.where(id: params[:id]).first

    redirect_to(genres_path) if @genre.nil?
  end
end
