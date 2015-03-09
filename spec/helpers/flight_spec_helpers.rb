module FlightSpecHelpers
  extend ActiveSupport::Concern

  included do
    let(:flight) { described_class.new(base_flight_params) }
    let(:local_date) { DateTime.now.to_s }
    let(:utc_date) { (DateTime.now + 1.hour).to_s }
    let(:base_flight_params) do
      {
        'flightId'               => 508028748,
        'carrierFsCode'          => 'U2',
        'flightNumber'           => '8355',
        'departureAirportFsCode' => 'LGW',
        'arrivalAirportFsCode'   => 'NCE',
        'departureDate' => {
          'dateLocal' => local_date,
          'dateUtc'   => utc_date
        }
      }
    end
    let(:gatwick) do
      {
        'airport' => {
          'active' => true,
          'city'   => 'London',
          'name'   => 'London Gatwick Airport',
          'fs'     => 'LGW'
        }
      }
    end
    let(:nice) do
      {
        'airport' => {
          'active' => true,
          'city'   => 'Nice',
          'name'   => 'Cote D\'Azur Airport',
          'fs'     => 'NCE'
        }
      }
    end
  end
end
