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
      before do
        allow(described_class).to receive(:npsso_cookie).and_return('EXPIRED')
      end

      it 'returns a NPSSO code expired error' do
        expect(Rails.logger).to receive(:error).with('PSN authorisation failed, NPSSO code has expired')
        expect{described_class.authenticate}.to raise_error(RuntimeError,
                                                            /PSN authorisation failed, NPSSO code has expired/)
      end
    end

    context 'when PSN returns an unknown error' do
      let (:response_location) do
        double('Response', headers: {
               'location' => 'https://my.account.sony.com/central/signin/?access_type=offline&
                client_id=<PSN_CLIENT_ID>&redirect_uri=com.scee.psxandroid.scecompcall%3A%2F%2Fredirect&
                response_type=code&scope=psn%3Amobile.v2.core+psn%3Aclientapp&auth_ver=v3&
                &error=no_code_for_you&error_code=4165&error_description=User+is+not+authenticated&
                no_captcha=false&cid=931b90e7-d59e-499f-8a07-6cc3db5d7a91'
        })
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response_location)
      end

      it 'returns a unhandled error error' do
        expect(Rails.logger).to receive(:error).with('Unhandled PSN auth error (no_code_for_you)')
        expect{described_class.authenticate}.to raise_error(RuntimeError,
                                                            /Unhandled PSN auth error \(no_code_for_you\)/)
      end
    end
  end
end