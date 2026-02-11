# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::Auth do
  describe '.authenticate' do
    before do
      allow(Rails.logger).to receive(:error)
    end

    context 'when the access token does not exist' do
      before do
        stub_psn_auth_success
      end

      it 'retrieves a new psn access token' do
        result = described_class.authenticate

        expect(result).not_to be_nil
      end
    end

    context 'when the NPSSO code has expired' do
      before do
        stub_psn_auth_npsso_expired
      end

      it 'returns a NPSSO code expired error' do
        expect(Rails.logger).to receive(:error).with('PSN authorisation failed, NPSSO code has expired')

        expect { described_class.authenticate }.to raise_error(RuntimeError,
                                                               'PSN authorisation failed, NPSSO code has expired')
      end
    end

    context 'when PSN returns a 429 too many requests error' do
      let(:response) do
        double('Response', # rubocop:disable RSpec/VerifiedDoubles
               headers: {
                 'server' => ['nginx'],
                 'content-type' => ['text/html;charset=utf-8'],
                 'content-length' => ['652'],
                 'content-language' => ['en'],
                 'date' => ['Sat, 29 Apr 2023 13:19:06 GMT'],
                 'connection' => ['keep-alive']
               },
               body: "<!doctype html><html lang=\"en\"><head><title>HTTP Status 429 – Too Many Requests</title>
                     <style type=\"text/css\">body {font-family:Tahoma,Arial,sans-serif;} h1, h2, h3,
                     b {color:white;background-color:#525D76;} h1 {font-size:22px;} h2 {font-size:16px;}
                     h3 {font-size:14px;} p {font-size:12px;} a {color:black;}
                     .line {height:1px;background-color:#525D76;border:none;}</style></head><body>
                     <h1>HTTP Status 429 – Too Many Requests</h1><hr class=\"line\" /><p><b>Type</b> Status Report</p>
                     <p><b>Description</b> The user has sent too many requests in a given amount of time
                     (\"rate limiting\").</p><hr class=\"line\" /><h3>Apache Tomcat/9.0.34</h3></body></html>")
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response)
      end

      it 'raises a failed to fetch PSN auth code error' do
        expect(Rails.logger).to receive(:error).with('Failed to fetch PSN auth code, location header missing')

        expect { described_class.authenticate }.to raise_error(RuntimeError,
                                                               'Failed to fetch PSN auth code, location header missing')
      end
    end

    context 'when PSN returns an unknown error' do
      let(:response) do
        double('Response', # rubocop:disable RSpec/VerifiedDoubles
               headers:
               {
                 'location' => 'https://my.account.sony.com/central/signin/?access_type=offline&
                 client_id=<PSN_CLIENT_ID>&redirect_uri=com.scee.psxandroid.scecompcall%3A%2F%2Fredirect&
                 response_type=code&scope=psn%3Amobile.v2.core+psn%3Aclientapp&auth_ver=v3&
                 &error=no_code_for_you&error_code=4165&error_description=User+is+not+authenticated&
                 no_captcha=false&cid=931b90e7-d59e-499f-8a07-6cc3db5d7a91'
               })
      end

      before do
        allow(HTTParty).to receive(:get).and_return(response)
      end

      it 'returns a unhandled error error' do
        expect(Rails.logger).to receive(:error).with('Unhandled PSN auth error (no_code_for_you)')

        expect { described_class.authenticate }.to raise_error(RuntimeError,
                                                               'Unhandled PSN auth error (no_code_for_you)')
      end
    end
  end
end
