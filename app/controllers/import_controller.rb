class ImportController < ApplicationController
  def igdb
  end

  def psn
    @psn_games = Import::PSN::Trophy.all_titles
  end
end
