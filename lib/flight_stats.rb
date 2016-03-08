require 'active_support/all'

module FlightStats
  module Status; end
  module Track; end

  class << self
    def arrivals_at_airport_for_date(airport, date, params = {})
      Flight.build_from(Api::Status::Airport.by_arriving_on_date(airport, date, params)['flightStatuses'])
    end

    def find_flight_schedule(timestamp, carrier, number, params = {})
      departing = params.delete(:method) == :departing
      if departing
        flight_params = FlightStats::Api::Schedule.by_departing_on_date(carrier, number, timestamp, params)
      else
        flight_params = FlightStats::Api::Schedule.by_arriving_on_date(carrier, number, timestamp, params)
      end

      puts flight_params
      ScheduledFlight.build_from(flight_params['scheduledFlights']).detect do |f|
        check = departing ? f.departure_time : f.arrival_time

        check >= timestamp - 5.minutes and check <= timestamp + 5.minutes
      end
    end

    def find_flight_status(timestamp, carrier, number, params = {})
      departing = params.delete(:method) != :departing
      if departing
        flight_params = FlightStats::Api::Status::Flight.by_departing_on_date(carrier, number, timestamp, params)['flightStatuses']
      else
        flight_params = FlightStats::Api::Status::Flight.by_arriving_on_date(carrier, number, timestamp, params)['flightStatuses']
      end

      Flight.build_from(flight_params).detect do |f|
        check = departing ? f.departure_time : f.arrival_time

        check >= timestamp - 5.minutes and check <= timestamp + 5.minutes
      end
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
