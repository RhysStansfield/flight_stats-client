module ApiHelpers
  extend ActiveSupport::Concern

  included do
    before do
      allow(described_class).to receive(:credentials).and_return('?appId=derpyid&appKey=derpykey')
    end
  end
end
