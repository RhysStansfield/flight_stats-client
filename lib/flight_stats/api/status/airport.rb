class FlightStats::Api::Status::Airport < FlightStats::Api::Status
  ALLOWED_PARAMS = {
    :all => {
      utc:             [true, false],
      numHours:        [*1..6],
      carrier:         'String',
      codeType:        ['IATA', 'ICAO', 'FS'],
      maxFlights:      'Fixnum',
      extendedOptions: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
    }
  }

  class << self
    include FlightStats::Api::AirportStatusAndTrack

    def by_departing_on_date(airport, date, params = {})
      params.merge!(caller: :by_departing_on_date)
      airport(arr_or_dep_at_airport_date_url_section(airport, date, 'dep'), params)
    end

    def by_arriving_on_date(airport, date, params = {})
      params.merge!(caller: :by_arriving_on_date)
      airport(arr_or_dep_at_airport_date_url_section(airport, date, 'arr'), params)
    end

    private

    def arr_or_dep_at_airport_date_url_section(airport, date, arr_or_dep)
      "#{airport}/#{arr_or_dep}/#{date_time_to_url_section(date)}"
    end
  end

  set_config resource_type: 'airport', allowed_param_options: ALLOWED_PARAMS
end
