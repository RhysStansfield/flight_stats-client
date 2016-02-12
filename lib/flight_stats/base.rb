class FlightStats::Base
  def self.attributes(*args)
    @attributes ||= ([] + superclass.instance_variable_get(:@attributes).to_a)
    @attributes += args

    args.each do |attribute|
      define_method(attribute) { instance_variable_get("@#{attribute}") }
    end
  end

  def self.all_attributes
    @attributes ||= []
  end

  def self.build_from(resources_params)
    resources_params.map { |resource_params| new(resource_params) }
  end

  def initialize(params = {})
    self.class.all_attributes.each do |attribute|
      camel_case_version = attribute.to_s.camelize(:lower)

      instance_variable_set("@#{attribute}", params[camel_case_version])
    end
  end
end

require_relative './airline'
require_relative './airport'
require_relative './codeshare'
require_relative './equipment'
require_relative './flight'
require_relative './scheduled_flight'
