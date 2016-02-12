require 'active_support/all'

module FlightStats
  module Status; end
  module Track; end

  class << self
    def arrivals_at_airport_for_date(airport, date, params = {})
      Flight.build_from(Api::Status::Airport.by_arriving_on_date(airport, date, params)['flightStatuses'])
    end

    def find_flight_schedule(date, carrier, number, params = {})
      if params.delete(:method) != :departing
        flight_params = FlightStats::Api::Schedule.by_arriving_on_date(carrier, number, date, params)
      else
        flight_params = FlightStats::Api::Schedule.by_departing_on_date(carrier, number, date, params)
      end

      puts flight_params      
      ScheduledFlight.build_from(flight_params['scheduledFlights']).first
    end

    def find_flight_status(date, carrier, number, params = {})
      if params.delete(:method) != :departing
        flight_params = FlightStats::Api::Status::Flight.by_arriving_on_date(carrier, number, date, params)['flightStatuses']
      else
        flight_params = FlightStats::Api::Status::Flight.by_departing_on_date(carrier, number, date, params)['flightStatuses']
      end

      Flight.build_from(flight_params).first
    end

    def flight_status_by_id(flight_id)
      Flight::Status.new(Api::Status::Flight.by_id(flight_id)['flightStatus'])
    end

    def track_flight_by_id(flight_id)
      Flight::Track.new(Api::Track::Flight.by_id(flight_id)['flightTrack'])
    end
  end
end

require_relative './flight_stats/api'
require_relative './flight_stats/base'
