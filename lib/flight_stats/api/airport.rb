class FlightStats::Api::Airport < FlightStats::Api
  ALLOWED_PARAMS = { all: { extendedOptions: ['useHttpErrors', 'languageCode:'] } }

  class << self
    def active(params = {})
      params.merge!(caller: :active)
      @active_aiports ||= airports('active', params)
    end

    def all(params = {})
      params.merge!(caller: :all)
      @all_aiports ||= airports('all', params)
    end

    def active_for_date(date, params = {})
      params.merge!(caller: :active_for_date)
      airports("active/#{date_to_url_section(date)}", params)
    end

    def by_flightstats_code(code, params = {})
      params.merge!(caller: :by_flightstats_code)
      airports("fs/#{code.upcase}", params)
    end

    def by_iata_code(code, params = {})
      params.merge!(caller: :by_iata_code)
      airports("iata/#{code.upcase}", params)
    end

    def by_iata_code_on_date(code, date, params = {})
      params.merge!(caller: :by_iata_code_on_date)
      airports("iata/#{code.upcase}/#{date_to_url_section(date)}", params)
    end

    def by_icao_code_on_date(code, date, params = {})
      params.merge!(caller: :by_icao_code_on_date)
      airports("icao/#{code.upcase}/#{date_to_url_section(date)}", params)
    end

    def on_date_by_code(code, date, params = {})
      params.merge!(caller: :on_date_by_code)
      airports("#{code.upcase}/#{date_to_url_section(date)}", params)
    end

    def by_city_code(city_code, params = {})
      params.merge!(caller: :by_city_code)
      airports("cityCode/#{city_code.upcase}", params)
    end

    def by_country_code(country_code, params = {})
      params.merge!(caller: :by_country_code)
      airports("countryCode/#{country_code.upcase}", params)
    end

    def within_radius_of_location(longitude, latitude, radius_miles, params = {})
      params.merge!(caller: :within_radius_of_location)
      airports("withinRadius/#{longitude}/#{latitude}/#{radius_miles}", params)
    end

    def current_by_code(code, params = {})
      params.merge!(caller: :current_by_code)
      airports("#{code.upcase}/today", params)
    end

    private

    def airports(query, params = {})
      get(build_url(body: query, params: params))['airports']
    end
  end

  set_config root: 'airports', version: 'v1', allowed_param_options: ALLOWED_PARAMS
end
