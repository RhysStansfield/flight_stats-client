module FlightStats::Api::StatusAndTrack
  attr_accessor :resource_type, :method_type, :resource_method_type

  def arr_or_dep_on_date_url_section(carrier, flight, date, arr_or_dep)
    "#{carrier}/#{flight}/#{arr_or_dep}/#{date_to_url_section(date)}"
  end

  def set_config(opts)
    super
    self.resource_type = opts[:resource_type] || self.resource_type || (superclass.resource_type if superclass.respond_to?(:resource_type))
    self.method_type   = opts[:method_type]   || self.method_type   || (superclass.method_type   if superclass.respond_to?(:method_type))
    self.resource_method_type = "#{resource_type}/#{method_type}"
  end

  private :arr_or_dep_on_date_url_section, :set_config
end
