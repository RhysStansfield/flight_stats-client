class FlightStats::Flight < FlightStats::Base
  attributes :flight_id, :carrier_fs_code, :flight_number, :departure_airport_fs_code,
             :arrival_airport_fs_code, :departure_date

  def self.build_from(flights_params, type = :status)
    target_class = (self.name + "::#{type.to_s.capitalize}").constantize

    flights_params.map { |flight_params| target_class.new(flight_params) }
  end

  def departure_airport
    return unless departure_airport_fs_code

    @departure_airport ||= FlightStats::Airport.new(
      FlightStats::Api::Airport.by_flightstats_code(departure_airport_fs_code)['airport']
    )
  end

  def arrival_airport
    return unless arrival_airport_fs_code

    @arrival_airport ||= FlightStats::Airport.new(
      FlightStats::Api::Airport.by_flightstats_code(arrival_airport_fs_code)['airport']
    )
  end

  def departure_date(format = :utc)
    return unless @departure_date

    date_for_format(@departure_date, format)
  end

  private

  def date_for_format(dates_hash, format)
    return unless dates_hash

    time_string = if /#{format}/i =~ 'dateLocal'
                    dates_hash['dateLocal']
                  elsif /#{format}/i =~ 'dateUtc'
                    dates_hash['dateUtc']
                  end

    return unless time_string

    DateTime.parse(time_string)
  end

  class Status < FlightStats::Flight
    attributes :arrival_date, :status, :schedule, :operational_times, :codeshares,
               :flight_durations, :airport_resources, :flight_equipment

    def self.build_from(flights_params)
      flights_params.map { |flight_params| new(flight_params) }
    end

    def active?
      status == 'A'
    end

    def canceled?
      status == 'C'
    end

    def diverted?
      status == 'D'
    end

    def landed?
      status == 'L'
    end

    def redirected?
      status == 'R'
    end

    def flight_type
      @flight_type ||= schedule['flightType'] if schedule
    end

    def service_classes
      @service_classes ||= schedule['serviceClasses'] if schedule
    end

    def restrictions
      @restrictions ||= schedule['restrictions'] if schedule
    end

    def scheduled_block_minutes
      @scheduled_block_minutes ||= flight_durations['scheduledBlockMinutes'] if flight_durations
    end

    def block_minutes
      @block_minutes ||= flight_durations['blockMinutes'] if flight_durations
    end

    def air_minutes
      @air_minutes ||= flight_durations['airMinutes'] if flight_durations
    end

    def taxi_out_minutes
      @taxi_out_minutes ||= flight_durations['taxiOutMinutes'] if flight_durations
    end

    def taxi_in_minutes
      @taxi_in_minutes ||= flight_durations['taxiInMinutes'] if flight_durations
    end

    def departure_terminal
      @departure_terminal ||= airport_resources['departureTerminal'] if airport_resources
    end

    def arrival_terminal
      @arrival_terminal ||= airport_resources['arrivalTerminal'] if airport_resources
    end

    def scheduled_equipment_iata_code
      return unless flight_equipment

      @scheduled_equipment_iata_code ||= flight_equipment['scheduledEquipmentIataCode']
    end

    def actual_equipment_iata_code
      return unless flight_equipment

      @actual_equipment_iata_code ||= flight_equipment['actualEquipmentIataCode']
    end

    def arrival_date(format = :utc)
      return unless @arrival_date

      date_for_format(@arrival_date, format)
    end

    def published_departure(format = :utc)
      return unless operational_times

      date_for_format(operational_times['publishedDeparture'], format)
    end

    def published_arrival(format = :utc)
      return unless operational_times

      date_for_format(operational_times['publishedArrival'], format)
    end

    def scheduled_gate_departure(format = :utc)
      return unless operational_times

      date_for_format(operational_times['scheduledGateDeparture'], format)
    end

    def estimated_gate_departure(format = :utc)
      return unless operational_times

      date_for_format(operational_times['estimatedGateDeparture'], format)
    end

    def actual_gate_departure(format = :utc)
      return unless operational_times

      date_for_format(operational_times['actualGateDeparture'], format)
    end

    def scheduled_gate_arrival(format = :utc)
      return unless operational_times

      date_for_format(operational_times['scheduledGateArrival'], format)
    end

    def estimated_gate_arrival(format = :utc)
      return unless operational_times

      date_for_format(operational_times['estimatedGateArrival'], format)
    end

    def actual_gate_arrival(format = :utc)
      return unless operational_times

      date_for_format(operational_times['actualGateArrival'], format)
    end

    def to_h
      h = {}

      (self.class.all_attributes + info_methods).each do |attribute|
        h[attribute.to_sym] = send(attribute)
      end
      h
    end

    private

    def info_methods
      %w(
        arrival_date published_departure published_arrival scheduled_gate_departure
        estimated_gate_departure actual_gate_departure scheduled_gate_arrival
        estimated_gate_arrival actual_gate_arrival
      )
    end
  end

  class Track < FlightStats::Flight
    DELAY_IRREGULAR_OPERATIONS = [
      'CANCELLATION', 'RETURN_TO_GATE', 'RETURN_FROM_AIRBOURNE'
    ]

    attributes :equipment, :delay_minutes, :bearing, :heading, :positions,
               :waypoints, :irregular_operations

    def self.build_from(flights_params)
      flights_params.map { |flight_params| new(flight_params) }
    end

    def canceled?
      return false unless irregular_operations

      irregular_operations.any? { |irregular_op| irregular_op['type'] == 'CANCELLATION' }
    end

    def diverted?
      return false unless irregular_operations

      irregular_operations.any? { |irregular_op| irregular_op['type'] == 'DIVERSION' }
    end

    def delayed?
      return true if delay_minutes
      return false unless irregular_operations

      irregular_operations.map { |ir| ir['type'] }.any? do |irregular_op|
        DELAY_IRREGULAR_OPERATIONS.include?(irregular_op)
      end
    end
  end
end
