class FlightStats::Api::Schedule < FlightStats::Api
  class << self
    include FlightStats::Api::StatusAndTrack
  end

  set_config root: 'schedules', version: 'v1', resource_type: 'flight', method_type: 'status'

  class << self
    def flight(query, params = {})
      get(build_url(body: "flight/#{query}", params: params))
    end

    def by_departing_on_date(carrier, flight, date, params = {})
      params.merge!(caller: :by_departing_on_date)
      flight(arr_or_dep_on_date_url_section(carrier, flight, date, 'departing'), params)
    end

    def by_arriving_on_date(carrier, flight, date, params = {})
      params.merge!(caller: :by_arriving_on_date)
      flight(arr_or_dep_on_date_url_section(carrier, flight, date, 'arriving'), params)
    end
  end
end
