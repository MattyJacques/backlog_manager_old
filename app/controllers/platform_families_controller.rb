# Controller responsible for handling PlatformFamiliy actions
class PlatformFamiliesController < ApplicationController
  def index
    @platform_families = PlatformFamily.all
  end

  def show
    @platform_family = PlatformFamily.where(id: params[:id]).first

    redirect_to(platform_families_path) if @platform_family.nil?
  end
end
