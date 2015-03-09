module FlightStats::Api::AirportStatusAndTrack
  def airport(query, params = {})
    get(build_url(body: "#{resource_method_type}/#{query}", params: params))
  end
end
