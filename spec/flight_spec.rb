require 'spec_helper'
require './spec/shared_examples/flight_examples'

describe FlightStats::Flight, flight: true do
  it_behaves_like 'a flight'

  context 'different types of subclass' do
    example 'can build subclass of status type' do
      flights_list = described_class.build_from([base_flight_params])

      expect(flights_list).to be_a_kind_of Array
      expect(flights_list.first).to be_a_kind_of FlightStats::Flight::Status
    end

    example 'can build subclass of track type' do
      flights_list = described_class.build_from([base_flight_params], :track)

      expect(flights_list).to be_a_kind_of Array
      expect(flights_list.first).to be_a_kind_of FlightStats::Flight::Track
    end
  end
end

describe FlightStats::Flight::Status, flight: true do
  it_behaves_like 'a flight'

  context 'extra attributes' do
    let(:flight_params) do
      base_flight_params.merge({
        'arrivalDate' => {
          'dateLocal' => local_date,
          'dateUtc'   => utc_date
        },
        'status'   => 'A',
        'schedule' => {
          'flightType'    => 'J',
          'serviceClasses'=> 'RFJY',
          'restrictions'  => ''
        },
        'operationalTimes' => {
          'publishedDeparture' => {
            'dateLocal' => '2015-03-03T16:10:00.000',
            'dateUtc'   => '2015-03-03T15:10:00.000Z'
          },
          'publishedArrival' => {
            'dateLocal' => '2015-03-03T18:00:00.000',
            'dateUtc'   => '2015-03-03T17:00:00.000Z'
          },
          'scheduledGateDeparture' => {
            'dateLocal' => '2015-03-03T16:10:00.000',
            'dateUtc'   => '2015-03-03T15:10:00.000Z'
          },
          'estimatedGateDeparture' => {
            'dateLocal' => '2015-03-03T16:10:00.000',
            'dateUtc'   => '2015-03-03T15:10:00.000Z'
          },
          'actualGateDeparture' => {
            'dateLocal' => '2015-03-03T16:12:00.000',
            'dateUtc'   => '2015-03-03T15:12:00.000Z'
          },
          'scheduledGateArrival' => {
            'dateLocal' => '2015-03-03T18:00:00.000',
            'dateUtc'   => '2015-03-03T17:00:00.000Z'
          },
          'estimatedGateArrival' => {
            'dateLocal' => '2015-03-03T17:49:00.000',
            'dateUtc'   => '2015-03-03T16:49:00.000Z'
          },
          'actualGateArrival' => {
            'dateLocal' => '2015-03-03T17:47:00.000',
            'dateUtc'   => '2015-03-03T16:47:00.000Z'
          }
        },
        'codeshares' => [
          { 'fsCode' => 'IB', 'flightNumber' => '8754', 'relationship' => 'S' }
        ],
        'flightDurations'  => { 'scheduledBlockMinutes' => 110, 'blockMinutes' => 95 },
        'airportResources' => { 'departureTerminal' => '4', 'arrivalTerminal' => '1' },
        'flightEquipment'  => { 'scheduledEquipmentIataCode' => 'CRK' }
      })
    end
    let(:flight_status) { described_class.new(flight_params) }

    context 'time formating' do
      example 'published_departure' do
        expect(flight_status.published_departure).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.published_departure(:utc)).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.published_departure(:local)).to eq DateTime.parse("2015-03-03T16:10:00.000")
      end

      example 'published_arrival' do
        expect(flight_status.published_arrival).to eq DateTime.parse("2015-03-03T17:00:00.000Z")
        expect(flight_status.published_arrival(:utc)).to eq DateTime.parse("2015-03-03T17:00:00.000Z")
        expect(flight_status.published_arrival(:local)).to eq DateTime.parse("2015-03-03T18:00:00.000")
      end

      example 'scheduled_gate_departure' do
        expect(flight_status.scheduled_gate_departure).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.scheduled_gate_departure(:utc)).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.scheduled_gate_departure(:local)).to eq DateTime.parse("2015-03-03T16:10:00.000")
      end

      example 'estimated_gate_departure' do
        expect(flight_status.estimated_gate_departure).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.estimated_gate_departure(:utc)).to eq DateTime.parse("2015-03-03T15:10:00.000Z")
        expect(flight_status.estimated_gate_departure(:local)).to eq DateTime.parse("2015-03-03T16:10:00.000")
      end

      example 'actual_gate_departure' do
        expect(flight_status.actual_gate_departure).to eq DateTime.parse("2015-03-03T15:12:00.000Z")
        expect(flight_status.actual_gate_departure(:utc)).to eq DateTime.parse("2015-03-03T15:12:00.000Z")
        expect(flight_status.actual_gate_departure(:local)).to eq DateTime.parse("2015-03-03T16:12:00.000")
      end

      example 'scheduled_gate_arrival' do
        expect(flight_status.scheduled_gate_arrival).to eq DateTime.parse("2015-03-03T17:00:00.000Z")
        expect(flight_status.scheduled_gate_arrival(:utc)).to eq DateTime.parse("2015-03-03T17:00:00.000Z")
        expect(flight_status.scheduled_gate_arrival(:local)).to eq DateTime.parse("2015-03-03T18:00:00.000")
      end

      example 'estimated_gate_arrival' do
        expect(flight_status.estimated_gate_arrival).to eq DateTime.parse("2015-03-03T16:49:00.000Z")
        expect(flight_status.estimated_gate_arrival(:utc)).to eq DateTime.parse("2015-03-03T16:49:00.000Z")
        expect(flight_status.estimated_gate_arrival(:local)).to eq DateTime.parse("2015-03-03T17:49:00.000")
      end

      example 'actual_gate_arrival' do
        expect(flight_status.actual_gate_arrival).to eq DateTime.parse("2015-03-03T16:47:00.000Z")
        expect(flight_status.actual_gate_arrival(:utc)).to eq DateTime.parse("2015-03-03T16:47:00.000Z")
        expect(flight_status.actual_gate_arrival(:local)).to eq DateTime.parse("2015-03-03T17:47:00.000")
      end
    end

    context 'status predicates' do
      let(:flight_with_status) do
        -> (status) { described_class.new(flight_params.dup.tap { |p| p['status'] = status }) }
      end
      example 'active?' do
        expect(flight_status.active?).to be true
      end

      example 'canceled?' do
        expect(flight_status.canceled?).to be false

        canceled_flight = flight_with_status.('C')
        expect(canceled_flight.canceled?).to be true
      end

      example 'diverted?' do
        expect(flight_status.diverted?).to be false

        diverted_flight = flight_with_status.('D')
        expect(diverted_flight.diverted?).to be true
      end

      example 'landed?' do
        expect(flight_status.landed?).to be false

        landed_flight = flight_with_status.('L')
        expect(landed_flight.landed?).to be true
      end

      example 'redirected?' do
        expect(flight_status.redirected?).to be false

        redirected_flight = flight_with_status.('R')
        expect(redirected_flight.redirected?).to be true
      end
    end

    context 'schedule' do
      example 'flight_type' do
        expect(flight_status.flight_type).to eq 'J'
      end

      example 'service_classes' do
        expect(flight_status.service_classes).to eq 'RFJY'
      end

      example 'restrictions' do
        expect(flight_status.restrictions).to eq ''
      end
    end

    context 'flight_durations' do
      let(:flight_with_durations) do
        -> (target, minutes) do
          described_class.new(flight_params.tap { |p| p['flightDurations'][target] = minutes })
        end
      end

      example 'scheduled_block_minutes' do
        expect(flight_status.scheduled_block_minutes).to eq 110
      end

      example 'block_minutes' do
        expect(flight_status.block_minutes).to eq 95
      end

      example 'air_minutes' do
        flight_with_air_minutes = flight_with_durations.('airMinutes', 80)
        expect(flight_with_air_minutes.air_minutes).to eq 80
      end

      example 'taxi_out_minutes' do
        flight_with_taxi_out_minutes = flight_with_durations.('taxiOutMinutes', 10)
        expect(flight_with_taxi_out_minutes.taxi_out_minutes).to eq 10
      end

      example 'taxi_in_minutes' do
        flight_with_taxi_in_minutes = flight_with_durations.('taxiInMinutes', 15)
        expect(flight_with_taxi_in_minutes.taxi_in_minutes).to eq 15
      end
    end

    context 'airport_resources' do
      example 'departure_terminal' do
        expect(flight_status.departure_terminal).to eq '4'
      end

      example 'arrival_terminal' do
        expect(flight_status.arrival_terminal).to eq '1'
      end
    end

    context 'flight_equipment' do
      example 'scheduled_equipment_iata_code' do
        expect(flight_status.scheduled_equipment_iata_code).to eq 'CRK'
      end

      example 'actual_equipment_iata_code' do
        flight_status_2 = described_class.new(
          flight_params.dup.tap { |p| p['flightEquipment']['actualEquipmentIataCode'] = 'CRK' }
        )
        expect(flight_status_2.actual_equipment_iata_code).to eq 'CRK'
      end
    end
  end
end

describe FlightStats::Flight::Track, flight: true do
  it_behaves_like 'a flight'

  context 'extra attributes' do
    let(:flight_params) do
      base_flight_params.merge({
        'equipment'    => '77W',
        'delayMinutes' => 1,
        'bearing'      => 322.57739964944585,
        'heading'      => 126.11246043222009,
        'positions'    => [
          {
            'lon'        => -0.45,
            'lat'        => 51.4667,
            'speedMph'   => 134,
            'altitudeFt' => 79,
            'source'     => 'derived',
            'date'       => '2015-03-09T06:23:14.000Z'
          },
          {
            'lon'      => -0.4643,
            'lat'      => 51.4732,
            'speedMph' => 11,
            'source'   => 'derived',
            'date'     => '2015-03-09T06:22:54.000Z'
          }
        ]
      })
    end
    let(:flight_track) { described_class.new(flight_params) }

    example 'equipment' do
      expect(flight_track.equipment).to eq '77W'
    end

    example 'delay_minutes' do
      expect(flight_track.delay_minutes).to eq 1
    end

    example 'bearing' do
      expect(flight_track.bearing).to eq 322.57739964944585
    end

    example 'heading' do
      expect(flight_track.heading).to eq 126.11246043222009
    end

    example 'positions' do
      expect(flight_track.positions).to be_a_kind_of Array
      expect(flight_track.positions.first).to be_a_kind_of Hash
      expect(flight_track.positions.first).to eq flight_params['positions'].first
    end

    context 'irregular ops predicates' do
      let(:track_with_irregular_op) do
        -> (op) do
          params = flight_params.dup.tap { |p| p['irregularOperations'] = [{ 'type' => op }] }
          described_class.new(params)
        end
      end

      example 'canceled?' do
        expect(flight_track.canceled?).to be false
        expect(track_with_irregular_op.('CANCELLATION').canceled?).to be true
      end

      example 'diverted?' do
        expect(flight_track.diverted?).to be false
        expect(track_with_irregular_op.('DIVERSION').diverted?).to be true
      end

      context 'delayed?' do
        let(:flight_params_2) { flight_params.dup.tap { |p| p['delayMinutes'] = nil } }
        let(:flight_track_2) { described_class.new(flight_params_2) }
        let(:track_with_irregular_op) do
          -> (op) do
            params = flight_params_2.dup.tap { |p| p['irregularOperations'] = [{ 'type' => op }] }
            described_class.new(params)
          end
        end

        example 'without delay minutes or irregular operations' do
          expect(flight_track_2.delayed?).to be false
        end

        example 'with delay_minutes' do
          expect(flight_track.delay_minutes).to eq 1
          expect(flight_track.delayed?).to be true
        end

        example 'without delay minutes but irregular operation' do
          %w(CANCELLATION RETURN_TO_GATE RETURN_FROM_AIRBOURNE).each do |delay|
            expect(track_with_irregular_op.(delay).delayed?).to be true
          end
        end
      end
    end
  end
end
