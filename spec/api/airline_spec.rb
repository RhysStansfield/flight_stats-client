require 'spec_helper'

describe FlightStats::Api::Airline, api_stubs: true do
  example 'ALLOWED_PARAMS' do
    expect(described_class::ALLOWED_PARAMS).to eq({
      all: { extendedOptions: ['useHttpErrors', 'languageCode:'] }
    })
  end

  context 'build_url' do
    example 'build_url no params' do
      expect(
        described_class.send(
          :build_url,
          body:   'iata/BA/2015/03/09',
          params: { caller: :by_iata_code_on_date }
        )
      ).to eq '/airlines/rest/v1/json/iata/BA/2015/03/09?appId=derpyid&appKey=derpykey'
    end
  end

  context 'airlines' do
    let(:date) { Date.new(2015, 3, 9) }

    example 'active' do
      expect(described_class).to receive(:airlines).with('active', caller: :active)
      described_class.active
    end

    example 'all' do
      expect(described_class).to receive(:airlines).with('all', caller: :all)
      described_class.all
    end

    example 'active_for_date' do
      expect(described_class).to receive(:airlines).with('active/2015/03/09', caller: :active_for_date)
      described_class.active_for_date(date)
    end

    example 'by_flightstats_code' do
      expect(described_class).to receive(:airlines).with('fs/BA', caller: :by_flightstats_code)
      described_class.by_flightstats_code('BA')
    end

    example 'by_iata_code' do
      expect(described_class).to receive(:airlines).with('iata/BA', caller: :by_iata_code)
      described_class.by_iata_code('BA')
    end

    example 'by_icao_code' do
      expect(described_class).to receive(:airlines).with('icao/BA', caller: :by_icao_code)
      described_class.by_icao_code('BA')
    end

    example 'by_iata_code_on_date' do
      expect(described_class).to receive(:airlines).with('iata/BA/2015/03/09', caller: :by_iata_code_on_date)
      described_class.by_iata_code_on_date('BA', date)
    end

    example 'by_icao_code_on_date' do
      expect(described_class).to receive(:airlines).with('icao/BA/2015/03/09', caller: :by_icao_code_on_date)
      described_class.by_icao_code_on_date('BA', date)
    end
  end
end
