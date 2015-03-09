shared_examples_for 'a flight that has a status or is tracked' do
  let(:track_or_status) { !!described_class.to_s.match(/Track/) ? 'tracks' : 'status' }
  let(:date) { Date.new(2015, 3, 9) }

  context 'actions' do
    example 'by_id' do
      t_or_s = track_or_status == 'tracks' ? 'track' : track_or_status

      expect(described_class).to(
        receive(:get).with(
          "/flightstatus/rest/v2/json/flight/#{t_or_s}/4001432?appId=derpyid&appKey=derpykey"
        )
      )
      described_class.by_id(4001432)
    end

    example 'by_departing_on_date' do
      expect(described_class).to(
        receive(:get).with(
          "/flightstatus/rest/v2/json/flight/#{track_or_status}/BA/100/dep/2015/03/09" \
          "?appId=derpyid&appKey=derpykey"
        )
      )
      described_class.by_departing_on_date('BA', 100, date)
    end

    example 'by_arriving_on_date' do
      expect(described_class).to(
        receive(:get).with(
          "/flightstatus/rest/v2/json/flight/#{track_or_status}/BA/100/arr/2015/03/09" \
          "?appId=derpyid&appKey=derpykey"
        )
      )
      described_class.by_arriving_on_date('BA', 100, date)
    end
  end
end
