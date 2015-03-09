shared_examples_for 'it has a status or is tracked' do
  let(:date) { DateTime.new(2015, 3, 9, 12, 40) }

  example 'arr_or_dep_on_date_url_section' do
    expect(
      described_class.send(:arr_or_dep_on_date_url_section, 'BA', '100', date, 'arr')
    ).to eq 'BA/100/arr/2015/03/09'
  end
end
