class FlightStats::Api::Track::Fleet < FlightStats::Api::Track
  ALLOWED_PARAMS = {
    :all => {
      includeFlightPlan:     [true, false],
      maxPositions:          'Fixnum',
      maxPositionAgeMinutes: 'Fixnum',
      sourceType:            ['raw', 'derived', 'all'],
      codeshares:            [true, false],
      airport:               'String',
      codeType:              ['IATA', 'ICAO', 'FS'],
      maxFlights:            'Fixnum',
      extended_options:      ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
    }
  }
  class << self
    include FlightStats::Api::FleetStatusAndTrack

    def active_flights(carrier, params = {})
      params.merge!(caller: :active_flights)
      fleet(carrier, params)
    end
  end

  set_config resource_type: 'fleet', allowed_param_options: ALLOWED_PARAMS
end
