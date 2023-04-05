class API::V1::IGDBController < ApplicationController
  def search
    raise "Invalid params" unless params[:name].present? && params[:limit].present?

    platform_id = Platform.find_by(abbreviation: params[:platform].split(',')[0])&.igdb_id
    render json: Import::IGDB::Games.search(params[:name], platform_id: platform_id, limit: params[:limit])
  end

  def import
  end
end
