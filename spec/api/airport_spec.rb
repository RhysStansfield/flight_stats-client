require 'spec_helper'

describe FlightStats::Api::Airport, api_stubs: true do
  example 'ALLOWED_PARAMS' do
    expect(described_class::ALLOWED_PARAMS).to eq({
      all: { extendedOptions: ['useHttpErrors', 'languageCode:'] }
    })
  end

  context 'build_url' do
    example 'no params' do
      expect(
        described_class.send(
          :build_url,
          body:   'iata/BA/2015/03/09',
          params: { caller: :by_iata_code_on_date }
        )
      ).to eq '/airports/rest/v1/json/iata/BA/2015/03/09?appId=derpyid&appKey=derpykey'
    end
  end

  context 'airports' do
    let(:date) { Date.new(2015, 3, 9) }

    example 'active' do
      expect(described_class).to receive(:airports).with('active', caller: :active)
      described_class.active
    end

    example 'all' do
      expect(described_class).to receive(:airports).with('all', caller: :all)
      described_class.all
    end

    example 'active_for_date' do
      expect(described_class).to receive(:airports).with('active/2015/03/09', caller: :active_for_date)
      described_class.active_for_date(date)
    end

    example 'by_flightstats_code' do
      expect(described_class).to receive(:airports).with('fs/BA', caller: :by_flightstats_code)
      described_class.by_flightstats_code('BA')
    end

    example 'by_iata_code' do
      expect(described_class).to receive(:airports).with('iata/BA', caller: :by_iata_code)
      described_class.by_iata_code('BA')
    end

    example 'by_iata_code_on_date' do
      expect(described_class).to receive(:airports).with('iata/BA/2015/03/09', caller: :by_iata_code_on_date)
      described_class.by_iata_code_on_date('BA', date)
    end

    example 'by_icao_code_on_date' do
      expect(described_class).to receive(:airports).with('icao/BA/2015/03/09', caller: :by_icao_code_on_date)
      described_class.by_icao_code_on_date('BA', date)
    end

    example 'on_date_by_code' do
      expect(described_class).to receive(:airports).with('BA/2015/03/09', caller: :on_date_by_code)
      described_class.on_date_by_code('ba', date)
    end

    example 'by_city_code' do
      expect(described_class).to receive(:airports).with('cityCode/CLO', caller: :by_city_code)
      described_class.by_city_code('CLO')
    end

    example 'by_country_code' do
      expect(described_class).to receive(:airports).with('countryCode/CO', caller: :by_country_code)
      described_class.by_country_code('CO')
    end

    example 'within_radius_of_location' do
      expect(described_class).to receive(:airports).with('withinRadius/-76.3/3.5/100', caller: :within_radius_of_location)
      described_class.within_radius_of_location(-76.3, 3.5, 100)
    end

    example 'current_by_code' do
      expect(described_class).to receive(:airports).with('SKHA/today', caller: :current_by_code)
      described_class.current_by_code('SKHA')
    end
  end
end
