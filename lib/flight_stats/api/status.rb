class FlightStats::Api::Status < FlightStats::Api
  class << self
    include FlightStats::Api::StatusAndTrack
  end

  set_config root: 'flightstatus', version: 'v2', resource_type: 'NA', method_type: 'status'
end

require_relative 'status/airport'
require_relative 'status/fleet'
require_relative 'status/flight'
