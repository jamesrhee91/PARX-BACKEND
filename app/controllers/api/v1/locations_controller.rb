class Api::V1::LocationsController < ApplicationController

  def index
    lat = params[:coords].split('&')[0].gsub('_', '.').to_f
    lon = params[:coords].split('&')[1].gsub('_', '.').to_f
    nearest = Location.where("ST_Distance(lonlat, 'POINT(#{lon} #{lat})') < 100")
    if nearest.blank?
      render json: {error: "No parking spaces available"}
    else
      nearest = nearest.map {|e| {lat: e.lonlat.latitude, lng: e.lonlat.longitude}}
      render json: {coords: nearest}
    end
  end

  def create
    lon = location_params[:lon]
    lat = location_params[:lat]
    loc = Location.new(lonlat: "POINT(#{lon} #{lat})")
    if loc.save
      render json: {success: loc}
    else
      render json: {error: "Something went wrong"}
    end
  end

  private

  def location_params
    params.require(:location).permit(:lat, :lon)
  end

end
