# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::ImportDefinedTrophiesJob do
  let(:account) { build(:psn_account, psn_id: 'Hakoom', account_id: '6796840136244039860') }

  describe '#perform' do
    context 'when account_id exists in database' do
      before do
        allow(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id).and_return(account)
      end

      it 'imports the defined trophies on the account' do
        expect(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id)
        expect(PSN::Client::User).not_to receive(:get_profile_from_username)
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
        expect(PSN::ScrapeProfileJob).to receive(:perform_now)

        described_class.perform_now(account.psn_id, should_scrape: true)
      end
    end

    context 'when account_id does not exist in database' do
      let(:profile_response) do
        {
          'onlineId' => 'Hakoom',
          'accountId' => '6796840136244039860',
          'npId' => 'SGFrb29tQGEyLnVz',
          'avatarUrls' => [{ 'size' => 'l', 'avatarUrl' => 'http://example.com/avatar.png' }],
          'plus' => 1,
          'aboutMe' => '',
          'languagesUsed' => %w[en en-GB],
          'trophySummary' => { 'level' => 999, 'progress' => 0, 'earnedTrophies' => {} },
          'isOfficiallyVerified' => false
        }
      end

      before do
        stub_psn_get_profile_from_username('Hakoom', profile_response)
      end

      it 'imports the defined trophies on the account' do
        expect(PSNAccount).to receive(:find_by).with(psn_id: account.psn_id)
        expect(PSN::Client::User).to receive(:get_profile_from_username).and_call_original
        expect(PSN::Services::ImportAccountDefinedTrophies).to receive(:import).with(account.account_id)
        expect(PSN::ScrapeProfileJob).to receive(:perform_now)

        described_class.perform_now(account.psn_id, should_scrape: true)
      end
    end
  end
end
