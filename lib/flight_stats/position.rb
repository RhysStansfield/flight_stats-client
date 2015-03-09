class Position < FlightStats::Base
  attributes :lon, :lat, :speed_mph, :altitude_ft, :source, :date

  def initialize(params = {})
    super
    @date = Time.parse(@date)
  end
end
