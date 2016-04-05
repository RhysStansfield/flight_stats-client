class FlightStats::ScheduledFlight < FlightStats::Base

  attributes :carrier_fs_code,
             :flight_number,
             :departure_airport_fs_code,
             :arrival_airport_fs_code,
             :departure_time,
             :arrival_time

  def arrival_time(format = :utc)
    return unless @arrival_time

    unless @arrival_time.is_a? DateTime
      @arrival_time = DateTime.parse(@arrival_time)
      @arrival_time = @arrival_time.change(offset: "+#{arrival_airport.utc_offset_hours.to_i}") if arrival_airport
    end

    format == :utc ? @arrival_time.utc : @arrival_time.change(offset: 0)
  end

  def departure_time(format = :utc)
    return unless @departure_time

    unless @departure_time.is_a? DateTime
      @departure_time = DateTime.parse(@departure_time)
      @departure_time = @departure_time.change(offset: "+#{departure_airport.utc_offset_hours.to_i}") if departure_airport
    end

    format == :utc ? @departure_time.utc : @departure_time.change(offset: 0)
  end

  def departure_airport
    return unless departure_airport_fs_code

    @departure_airport ||= FlightStats::Airport.new(
      FlightStats::Api::Airport.by_iata_code_on_date(departure_airport_fs_code, attributes['departureTime'])
    )
  end

  def arrival_airport
    return unless arrival_airport_fs_code

    @arrival_airport ||= FlightStats::Airport.new(
      FlightStats::Api::Airport.by_iata_code_on_date(arrival_airport_fs_code, attributes['arrivalTime'])
    )
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
