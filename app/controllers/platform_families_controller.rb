# Controller responsible for handling PlatformFamiliy actions
class PlatformFamiliesController < ApplicationController
  def index
    @platform_families = PlatformFamily.all
  end

  def show
    @platform_family = PlatformFamily.find(params[:id])
  end
end
