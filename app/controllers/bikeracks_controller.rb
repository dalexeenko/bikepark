class BikeracksController < ApplicationController
  before_action :set_bikerack, only: [:show, :edit, :update, :destroy]

  # Find bikeracks closest to the given coordinates
  def getNearestBikeracks
    point = RGeo::Geographic.spherical_factory(:srid => 4326).point(params[:longitude].to_f, params[:latitude].to_f)

    # MAX number of bikeracks to look for
    number = 1

    racks = Bikerack.find_by_sql("
      SELECT *,
      ST_Distance(
        Bikeracks.latlng,
        ST_GeomFromText('#{ point } ')
      ) as distance
      FROM Bikeracks
      WHERE ST_Distance(
        Bikeracks.latlng,
        ST_GeomFromText('#{ point }')) > 0
      ORDER by ST_Distance(
        Bikeracks.latlng,
        ST_GeomFromText('#{ point }')
      )
      limit #{number};")

    render :json => racks
  end

  def getBikeracksWithinBounds
    swLat = params[:swLat].to_f;
    swLng = params[:swLng].to_f;
    neLat = params[:neLat].to_f;
    neLng = params[:neLng].to_f;

    racks = Bikerack.find_by_sql("
      SELECT *
      FROM Bikeracks
      WHERE ST_Within(
        Bikeracks.latlng::geometry,
        ST_GeomFromText(
            'POLYGON((
                #{swLng} #{swLat},
                #{neLng} #{swLat},
                #{neLng} #{neLat},
                #{swLng} #{neLat},
                #{swLng} #{swLat}))',
            4326))
      ;")

    render :json => racks
  end

  # GET /bikeracks
  # GET /bikeracks.json
  def index
    @bikeracks = Bikerack.all
  end

  # GET /bikeracks/1
  # GET /bikeracks/1.json
  def show
  end

  # GET /bikeracks/new
  def new
    @bikerack = Bikerack.new
  end

  # GET /bikeracks/1/edit
  def edit
  end

  # POST /bikeracks
  # POST /bikeracks.json
  def create
    @bikerack = Bikerack.new(bikerack_params)

    respond_to do |format|
      if @bikerack.save
        format.html { redirect_to @bikerack, notice: 'Bikerack was successfully created.' }
        format.json { render action: 'show', status: :created, location: @bikerack }
      else
        format.html { render action: 'new' }
        format.json { render json: @bikerack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bikeracks/1
  # PATCH/PUT /bikeracks/1.json
  def update
    respond_to do |format|
      if @bikerack.update(bikerack_params)
        format.html { redirect_to @bikerack, notice: 'Bikerack was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @bikerack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bikeracks/1
  # DELETE /bikeracks/1.json
  def destroy
    @bikerack.destroy
    respond_to do |format|
      format.html { redirect_to bikeracks_url }
      format.json { head :no_content }
    end
  end

  # $TODO: remove skip_before_filter
  skip_before_filter :verify_authenticity_token

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bikerack
      @bikerack = Bikerack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def bikerack_params
      params.require(:bikerack).permit(:rack_id, :name, :address, :latlng, :latitude, :longitude)
    end
end
