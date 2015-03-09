class FlightStats::Api::Airline < FlightStats::Api
  ALLOWED_PARAMS = { all: { extendedOptions: ['useHttpErrors', 'languageCode:'] } }

  class << self
    def active(params = {})
      params.merge!(caller: :active)
      @active_airlines ||= airlines('active', params)
    end

    def all(params = {})
      params.merge!(caller: :all)
      @all_airlines ||= airlines('all', params)
    end

    def active_for_date(date, params = {})
      params.merge!(caller: :active_for_date)
      airlines("active/#{date_to_url_section(date)}", params)
    end

    def by_flightstats_code(code, params = {})
      params.merge!(caller: :by_flightstats_code)
      airlines("fs/#{code.upcase}", params)
    end

    def by_iata_code(code, params = {})
      params.merge!(caller: :by_iata_code)
      airlines("iata/#{code.upcase}", params)
    end

    def by_icao_code(code, params = {})
      params.merge!(caller: :by_icao_code)
      airlines("icao/#{code.upcase}", params)
    end

    def by_iata_code_on_date(code, date, params = {})
      params.merge!(caller: :by_iata_code_on_date)
      airlines("iata/#{code.upcase}/#{date_to_url_section(date)}", params)
    end

    def by_icao_code_on_date(code, date, params = {})
      params.merge!(caller: :by_icao_code_on_date)
      airlines("icao/#{code.upcase}/#{date_to_url_section(date)}", params)
    end

    private

    def airlines(query, params = {})
      get(build_url(body: query, params: params))['airlines']
    end
  end

  set_config root: 'airlines', version: 'v1', allowed_param_options: ALLOWED_PARAMS
end
