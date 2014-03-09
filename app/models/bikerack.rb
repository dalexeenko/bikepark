class Bikerack < ActiveRecord::Base
  set_rgeo_factory_for_column(:latlng,
    RGeo::Geographic.spherical_factory(:srid => 4326))

  reverse_geocoded_by :latitude, :longitude,
    :address => :address
  after_validation :reverse_geocode

  # Connect to Socrata dataset, fetch the bikerack entries and store the new ones
  # in PostgreSQL
  def self.populate
    client = SODA::Client.new(
      {
        :domain => "data.seattle.gov",
        :app_token => "vTyqTnVWsKNJmTJLmaH1xPd47"
      })

    # Dataset: https://data.seattle.gov/Transportation/City-of-Seattle-Bicycle-Racks/vncn-umqp
    racks = client.get("vncn-umqp.json")

    racks.each do |rack|
      unless exists? :name => rack.objectid
        # $TODO: get proper fix for google's geocoder OVER_QUERY_LIMIT
        sleep 1

        create!(
          :rack_id => rack.objectid,
          :name => rack.unitdesc,
          :latitude => rack.latitude,
          :longitude => rack.longitude,
          :latlng => RGeo::Geographic.spherical_factory(:srid => 4326).point(rack.longitude, rack.latitude)
        )
      end
    end
  end
end
