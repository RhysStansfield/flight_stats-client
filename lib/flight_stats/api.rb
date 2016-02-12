require 'httparty'

class FlightStats::Api
  include HTTParty

  base_uri 'https://api.flightstats.com/flex'

  APP_ID  = ENV['FLIGHT_STATS_APP_ID']
  APP_KEY = ENV['FLIGHT_STATS_KEY']
  VALID_PARAM_VALUE_CLASSES = [String, Symbol, TrueClass, FalseClass, Fixnum, Float]

  class << self
    attr_accessor :root, :version, :format, :allowed_param_options

    private

    def allowed_for?(key, value, calling_method)
      if valid_params_for_all_routes.present? && (allowed_values = valid_params_for_all_routes[key])
        param_value_valid?(value, allowed_values)
      elsif (permitted_for_this_action = allowed_param_options[calling_method])
        allowed_values = permitted_for_this_action[key]

        param_value_valid?(value, allowed_values)
      elsif (permitted_for_action = allowed_param_array_keys_include(calling_method))
        allowed_values = allowed_param_options[permitted_for_action][key]

        param_value_valid?(value, allowed_values)
      else
        false
      end
    end

    def allowed_param_array_keys_include(calling_method)
      allowed_param_options.keys.detect { |key| key.is_a?(Array) && key.include?(calling_method) }
    end

    def build_param_queries(params)
      return unless params

      params = extract_valid_param_options(params)

      # This is stupid
      ''.tap do |str|
        params.each_pair do |key, value|
          value = value.is_a?(Array) ? value.join(',') : value
          str << "&#{key}=#{value}"
        end
      end
    end

    def build_url(opts = {})
      body   = opts.fetch(:body)
      params = build_param_queries(opts[:params])

      "/#{root}/rest/#{version}/#{format}/#{body}#{credentials}#{params}".tap { |url| puts url }
    end

    def extract_valid_param_options(params = {})
      calling_method = params.delete(:caller)

      params.inject({}) do |memo, (key, value)|
        memo[key] = value if allowed_for?(key, value, calling_method)
        memo
      end
    end

    def param_value_correct_class?(value, allowed_values)
      return true if allowed_values.constantize == value.class
      false
    end

    def param_value_in_allowed_values?(value, allowed_values)
      return false unless VALID_PARAM_VALUE_CLASSES.include?(value.class)
      return true if allowed_values.include?(value)
      return true if allowed_values.any? { |allowed_val| /#{allowed_val}/i.match value.to_s }
      false
    end

    def param_value_valid?(value, allowed_values)
      return false unless allowed_values

      case allowed_values
      when Array
        param_value_in_allowed_values?(value, allowed_values)
      when String
        param_value_correct_class?(value, allowed_values)
      end
    end

    def valid_params_for_all_routes
      allowed_param_options[:all]
    end

    def date_to_url_section(time)
      time.strftime("%Y/%m/%d")
    end

    def date_time_to_url_section(time)
      date_to_url_section(time) << time.strftime("/%H")
    end

    def credentials
      "?appId=#{APP_ID}&appKey=#{APP_KEY}"
    end

    def set_config(opts)
      self.root    = opts[:root]    || root    || (superclass.root    if superclass.respond_to?(:root))
      self.version = opts[:version] || version || (superclass.version if superclass.respond_to?(:version))
      self.format  = opts[:format]  || format  || (superclass.format  if superclass.respond_to?(:format)) || 'json'
      self.allowed_param_options = opts[:allowed_param_options]
    end
  end
end

require_relative './api/mixins/airport_status_and_track'
require_relative './api/mixins/fleet_status_and_track'
require_relative './api/mixins/flight_status_and_track'
require_relative './api/mixins/status_and_track'

require_relative './api/airline'
require_relative './api/airport'
require_relative './api/status'
require_relative './api/track'
require_relative './api/schedule'
