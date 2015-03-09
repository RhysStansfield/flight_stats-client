class FlightStats::Api::Track::Flight < FlightStats::Api::Track
  ALLOWED_PARAMS = {
    :all => {
      includeFlightPlan:      [true, false],
      maxPositions:           'Fixnum',
      maxPositionsAgeMinutes: 'Fixnum',
      extendedOptions:       ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
    },
    [:by_departing_on_date, :by_arriving_on_date] => {
      hourOfDay: [*0..23],
      utc:       [true, false],
      numHours:  [*0..24],
      airport:   'String',
      codeType:  ['IATA', 'ICAO', 'FS']
    }
  }

  class << self
    include FlightStats::Api::FlightStatusAndTrack

    # Because FlightStats API is foolish and for just the by_id url uses flight/track rather than flight/tracks...
    # Does make semantic sense as tracking singular flight but annoying to code around
    def flight(query, params = {})
      resource_tracks = 'flight/track' if /by_id/.match caller.first
      get(build_url(body: "#{resource_tracks || resource_method_type}/#{query}", params: params))
    end
  end

  set_config resource_type: 'flight', allowed_param_options: ALLOWED_PARAMS
end
