require 'rails_helper'

RSpec.describe Import::PSN::API::Client do
  describe '.get', :vcr do
    context 'when the access token does not exist' do
      it 'retrieves the token and posts the request' do
        result = described_class.get("/trophy/v1/users/me/trophySummary")

        expect(result['accountId']).to_not be_nil
      end
    end
    
    context 'when access token has expired' do
      it 'refreshes the access token and retries' do
        Rails.cache.write('psn_token', 'fake_expired_token')

        result = described_class.get("/trophy/v1/users/me/trophySummary")

        expect(result['accountId']).to_not be_nil
      end
    end
  end
end