require 'rails_helper'

RSpec.describe Import::PSN::API::Auth, tag: :psn do
  describe '.authenticate', :vcr, tag: :psn do
    context 'when the access token does not exist' do
      it 'retrieves a new psn access token' do
        result = described_class.authenticate

        expect(result.token).to_not be_nil
        expect(result.expires_in).to_not be_nil
      end
    end
  end
end