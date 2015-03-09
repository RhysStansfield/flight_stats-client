require 'spec_helper'

describe FlightStats::Api::Status::Fleet, api_stubs: true do
  example 'ALLOWED_PARAMS' do
    expect(described_class::ALLOWED_PARAMS).to eq({
      :all => {
        hourOfDay:        [*0..23],
        utc:              [true, false],
        numHours:         [*1..6],
        codeshares:       [true, false],
        airport:          'String',
        codeType:         ['IATA', 'ICAO', 'FS'],
        maxFlights:       'Fixnum',
        extended_options: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
      }
    })
  end

  context 'build_url' do
    let(:build_url_params) do
      {
        body:   'LHR/2015/03/09/10',
        params: { caller: :by_departing_on_date }
      }
    end

    example 'no params' do
      expect(
        described_class.send(:build_url, build_url_params)
      ).to eq '/flightstatus/rest/v2/json/LHR/2015/03/09/10?appId=derpyid&appKey=derpykey'
    end

    example 'with valid params' do
      params = build_url_params.dup
      params[:params][:utc] = true
      params[:params][:numHours] = 5

      expect(
        described_class.send(:build_url, params)
      ).to eq '/flightstatus/rest/v2/json/LHR/2015/03/09/10?appId=derpyid&appKey=derpykey&utc=true&numHours=5'
    end

    example 'with invalid params' do
      params = build_url_params.dup
      params[:params][:utc] = true
      params[:params][:numHours] = 8

      expect(
        described_class.send(:build_url, params)
      ).to eq '/flightstatus/rest/v2/json/LHR/2015/03/09/10?appId=derpyid&appKey=derpykey&utc=true'
    end
  end

  context 'actions' do
    let(:date) { DateTime.new(2015, 3, 9, 10) }

    example 'departures_on_date' do
      expect(described_class).to(
        receive(:get).with(
          '/flightstatus/rest/v2/json/fleet/status/BA/dep/2015/03/09' \
          '?appId=derpyid&appKey=derpykey&hourOfDay=10'
        )
      )
      described_class.departures_on_date('BA', date, hourOfDay: 10)
    end
  end
end
