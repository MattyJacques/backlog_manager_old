# Controller responsible for handling Platform actions
class PlatformsController < ApplicationController
  def index
    @platforms = Platform.all
  end

  def show
    @platform = Platform.where(id: params[:id]).first

    redirect_to(platforms_path) if @platform.nil?
  end
end
