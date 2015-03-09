class FlightStats::Api::Status::Flight < FlightStats::Api::Status
  ALLOWED_PARAMS = {
    :all => {
      extendedOptions: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
      },
    [:by_departing_on_date, :by_arriving_on_date] => {
      utc:      [true, false],
      airport:  'String',
      codeType: ['IATA', 'ICAO', 'FS']
    }
  }

  class << self
    include FlightStats::Api::FlightStatusAndTrack
  end

  set_config resource_type: 'flight', allowed_param_options: ALLOWED_PARAMS
end
