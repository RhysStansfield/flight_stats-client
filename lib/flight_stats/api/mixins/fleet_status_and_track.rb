module FlightStats::Api::FleetStatusAndTrack
  def fleet(query, params = {})
    get(build_url(body: "#{resource_method_type}/#{query}", params: params))
  end
end
