# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::Base do
  describe '.get' do
    let(:account_id) { '6796840136244039860' }
    let(:url) { "https://ps5.np.playstation.net/api/trophy/v1/users/#{account_id}/trophySummary" }
    let(:response_body) do
      {
        'accountId' => account_id,
        'trophyLevel' => 500,
        'progress' => 50,
        'tier' => 10,
        'earnedTrophies' => { 'bronze' => 1000, 'silver' => 500, 'gold' => 200, 'platinum' => 50 }
      }
    end

    context 'when the access token does not exist' do
      before do
        stub_psn_auth_success
        stub_request(:get, url)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'retrieves the token and sends the request' do
        result = described_class.get(url)

        expect(result['accountId']).not_to be_nil
      end
    end

    context 'when sending the request' do
      before do
        stub_psn_auth_success
        stub_request(:get, url)
          .with(headers: { 'Apollo-Require-Preflight' => 'true' })
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      it 'sends the apollo-require-preflight header so PSN does not block it as a CSRF risk' do
        result = described_class.get(url)

        expect(result['accountId']).not_to be_nil
      end
    end

    context 'when access token has expired' do
      before do
        stub_psn_auth_success
        Rails.cache.write('psn_token', 'fake_expired_token')

        stub_request(:get, url)
          .to_return(
            { status: 401, body: { error: { message: 'Unauthorized' } }.to_json },
            { status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' } }
          )
      end

      it 'refreshes the access token and retries' do
        result = described_class.get(url)

        expect(result['accountId']).not_to be_nil
      end
    end
  end
end
