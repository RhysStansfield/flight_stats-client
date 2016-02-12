class FlightStats::ScheduledFlight < FlightStats::Base
  
  attributes :carrier_fs_code, 
             :flight_number, 
             :departure_airport_fs_code,
             :arrival_airport_fs_code, 
             :departure_time,
             :arrival_time

  def arrival_time(format = :utc)
    return unless @arrival_time

    DateTime.parse(@arrival_time)
  end

  def departure_time(format = :utc)
    return unless @departure_time

    DateTime.parse(@departure_time)
  end

  class << self

    def build_from(flights_params)
      target_class = (self.name).constantize

      flights_params.map { |flight_params| target_class.new(flight_params) }
    end

    def request_uri(carrier, flight, date, arr_or_dep)
      "#{carrier}/#{flight}/#{arr_or_dep}/#{date.strftime("%Y/%m/%d")}"
    end
  end
end
