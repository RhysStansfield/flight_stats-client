module FlightStats::Api::FlightStatusAndTrack
  def flight(query, params = {})
    get(build_url(body: "#{resource_method_type}/#{query}", params: params))
  end

  def by_id(flight_id, params = {})
    params.merge!(caller: :by_id)
    flight(flight_id, params)
  end

  def by_departing_on_date(carrier, flight, date, params = {})
    params.merge!(caller: :by_departing_on_date)
    flight(arr_or_dep_on_date_url_section(carrier, flight, date, 'dep'), params)
  end

  def by_arriving_on_date(carrier, flight, date, params = {})
    params.merge!(caller: :by_arriving_on_date)
    flight(arr_or_dep_on_date_url_section(carrier, flight, date, 'arr'), params)
  end
end
