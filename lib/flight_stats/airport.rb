class FlightStats::Airport < FlightStats::Base
  attributes :fs, :iata, :icao, :name, :street1, :city, :country, :city_code,
             :country_code, :country_name, :region_name, :time_zone_region_name,
             :local_time, :utc_offset_hours, :latitude, :longitude,
             :elevation_feet, :classification, :active, :delay_index_url,
             :weather_url
end
