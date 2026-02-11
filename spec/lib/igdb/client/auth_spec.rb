# frozen_string_literal: true

RSpec.describe IGDB::Client::Auth do
  describe '.authenticate' do
    before do
      stub_igdb_auth_success
    end

    it 'retrieves a new psn access token' do
      result = described_class.authenticate

      expect(result).not_to be_nil
    end
  end
end
