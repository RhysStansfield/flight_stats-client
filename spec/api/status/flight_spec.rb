require 'spec_helper'
require './spec/shared_examples/flight_status_and_track_examples'

describe FlightStats::Api::Status::Flight, api_stubs: true do
  example 'ALLOWED_PARAMS' do
    expect(described_class::ALLOWED_PARAMS).to eq({
      :all => {
        extendedOptions: ['useInlinedReferences', 'useHttpErrors', 'includeDeltas']
        },
      [:by_departing_on_date, :by_arriving_on_date] => {
        utc:      [true, false],
        airport:  'String',
        codeType: ['IATA', 'ICAO', 'FS']
      }
    })
  end

  it_behaves_like 'a flight that has a status or is tracked'
end
