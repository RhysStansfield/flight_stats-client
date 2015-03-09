shared_examples_for 'a flight' do
  example 'accessors for all passed in attrs' do
    expect(flight.flight_id).to be 508028748
    expect(flight.carrier_fs_code).to eq 'U2'
    expect(flight.flight_number).to eq '8355'
    expect(flight.departure_airport_fs_code).to eq 'LGW'
    expect(flight.arrival_airport_fs_code).to eq 'NCE'
  end

  example 'departure date formats' do
    expect(flight.departure_date).to eq DateTime.parse(utc_date)
    expect(flight.departure_date(:utc)).to eq DateTime.parse(utc_date)
    expect(flight.departure_date(:local)).to eq DateTime.parse(local_date)
  end

  example 'finding departure airport' do
    expect(FlightStats::Api::Airport).to(
      receive(:by_flightstats_code).with('LGW').and_return(gatwick)
    )
    expect(flight.departure_airport).to be_a_kind_of FlightStats::Airport
  end

  example 'finding arrival airport' do
    expect(FlightStats::Api::Airport).to(
      receive(:by_flightstats_code).with('NCE').and_return(nice)
    )
    expect(flight.arrival_airport).to be_a_kind_of FlightStats::Airport
  end
end
