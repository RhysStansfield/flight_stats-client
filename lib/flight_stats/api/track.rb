class FlightStats::Api::Track < FlightStats::Api
  class << self
    include FlightStats::Api::StatusAndTrack
  end

  set_config root: 'flightstatus', version: 'v2', resource_type: 'NA', method_type: 'tracks'
end

require_relative 'track/airport'
require_relative 'track/fleet'
require_relative 'track/flight'
