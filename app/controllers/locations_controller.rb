class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def index
    @locations = Location.all
  end


  def show
    @hash = Gmaps4rails.build_markers(@location) do |location, marker|
      marker.lat location.latitude
      marker.lng location.longitude
      marker.infowindow "<a target='blank' href='https://www.google.com/maps/place/"+"#{location.address}"+"'>Get Directions With Google Maps</a>"
      marker.json({ title: location.name })
    end
  end


  def new
    @location = Location.new
  end


  def edit
  end


  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render :show, status: :created, location: @location }
      else
        format.html { render :new }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { render :show, status: :ok, location: @location }
      else
        format.html { render :edit }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url, notice: 'Location was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def search_medical
    @location = params[:search]
    @distance = params[:miles]
    @medical = Medical.near(@location, @distance)

    if @location.empty?
      flash[:notice] = "You can't search without a search term; please enter a location and retry!"
      redirect_to root_url
    else
      if @medical.length < 1
        flash[:notice] = "Sorry! We couldn't find any farms within #{@distance} miles of #{@location}."
        redirect_to root_url
      else
        search_map(@medical)
      end
    end

  end

  private
    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params.require(:location).permit(:address, :latitiude, :longitude, :name, :hours_open)
    end

    def search_map(medical)
      @medical = medical
        @hash = Gmaps4rails.build_markers(@medical) do |location, marker|
        marker.lat location.latitude
        marker.lng location.longitude
        marker.infowindow "<a href='/location/"+"#{location.id}"+"'>#{location.name}, #{location.address}</a>"
        marker.json({ title: location.name, id: location.id })
      end
    end
end
