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

    context 'when the NPSSO code has expired' do
      it 'returns a NPSSO code expired error' do
        expect(Rails.logger).to receive(:error).with('PSN authorisation failed, NPSSO code has expired')
        expect{described_class.authenticate}.to raise_error(RuntimeError,
                                                            /PSN authorisation failed, NPSSO code has expired/)
      end
    end

    context 'when PSN returns an unknown error' do
      it 'returns a unhandled error error' do
        expect(Rails.logger).to receive(:error).with('Unhandled PSN auth error (something_went_wrong)')
        expect{described_class.authenticate}.to raise_error(RuntimeError,
                                                            /Unhandled PSN auth error \(something_went_wrong\)/)
      end
    end
  end
end