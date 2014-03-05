json.array!(@bikeracks) do |bikerack|
  json.extract! bikerack, :id, :rack_id, :name, :address, :latlng, :latitude, :longitude
  json.url bikerack_url(bikerack, format: :json)
end
