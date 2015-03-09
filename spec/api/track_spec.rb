require 'spec_helper'
require './spec/shared_examples/status_and_track_examples'

describe FlightStats::Api::Track do
  it_behaves_like 'it has a status or is tracked'
end
