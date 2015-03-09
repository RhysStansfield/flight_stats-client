class FlightStats::Api::Track::Airport < FlightStats::Api::Track
  ALLOWED_PARAMS = {
    :all => {
      utc:              [true, false],
      numHours:         [*1..6],
      carrier:          'String',
      codeType:         ['IATA', 'ICAO', 'FS'],
      maxFlights:       'Fixnum',
      extended_options: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
    }
  }

  class << self
    include FlightStats::Api::AirportStatusAndTrack

    def departures(airport, params = {})
      params.merge!(caller: :departures)
      airport("#{airport}/dep", params)
    end

    def arrivals(airport, params = {})
      params.merge!(caller: :arrivals)
      airport("#{airport}/arr", params)
    end
  end

  set_config resource_type: 'airport', allowed_param_options: ALLOWED_PARAMS
end
