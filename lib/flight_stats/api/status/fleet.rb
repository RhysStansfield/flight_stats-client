class FlightStats::Api::Status::Fleet < FlightStats::Api::Status
  ALLOWED_PARAMS = {
    :all => {
      hourOfDay:        [*0..23],
      utc:              [true, false],
      numHours:         [*1..6],
      codeshares:       [true, false],
      airport:          'String',
      codeType:         ['IATA', 'ICAO', 'FS'],
      maxFlights:       'Fixnum',
      extended_options: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
    }
  }

  class << self
    include FlightStats::Api::FleetStatusAndTrack

    def departures_on_date(carrier, date, params = {})
      params.merge!(caller: :departures_on_date)
      fleet("#{carrier}/dep/#{date_to_url_section(date)}", params)
    end
  end

  set_config resource_type: 'fleet', allowed_param_options: ALLOWED_PARAMS
end
