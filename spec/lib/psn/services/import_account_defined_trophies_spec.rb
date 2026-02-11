# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::ImportAccountDefinedTrophies do
  describe '.import' do
    let(:account) { build(:psn_account, :account_id) }
    let(:psn_response) do
      [
        {
          'npServiceName' => 'trophy',
          'npCommunicationId' => 'NPWR00117_00',
          'trophySetVersion' => '01.12',
          'trophyTitleName' => 'SUPER STARDUST™ HD',
          'trophyTitleDetail' => 'SUPER STARDUST™ HD',
          'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00117_00_00E2D6C0A2BB7475BC6C26626F04790CDAD0507E33/797A9F853E90AE722EE315B9A8747E0842390FF3.PNG',
          'trophyTitlePlatform' => 'PS3',
          'hasTrophyGroups' => false,
          'definedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
          'progress' => 100,
          'earnedTrophies' => { 'bronze' => 9, 'silver' => 6, 'gold' => 2, 'platinum' => 0 },
          'hiddenFlag' => false,
          'lastUpdatedDateTime' => '2008-07-16T10:59:08Z'
        },
        {
          'npServiceName' => 'trophy',
          'npCommunicationId' => 'NPWR15881_00',
          'trophySetVersion' => '01.02',
          'trophyTitleName' => 'Redeemer: Enhanced Edition',
          'trophyTitleDetail' => 'Run around. Shoot things. Score points. Have fun.',
          'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR15881_00_0049D3850CFAD612BC8B61B62571671760D844E7FE/C11620A55AFCBB03953E46F3C8EBFF41C0BCA497.PNG',
          'trophyTitlePlatform' => 'PS4',
          'hasTrophyGroups' => false,
          'definedTrophies' => { 'bronze' => 15, 'silver' => 3, 'gold' => 0, 'platinum' => 0 },
          'progress' => 90,
          'earnedTrophies' => { 'bronze' => 15, 'silver' => 2, 'gold' => 0, 'platinum' => 0 },
          'hiddenFlag' => false,
          'lastUpdatedDateTime' => '2023-06-16T21:05:11Z'
        }
      ]
    end

    before do
      allow(PSN::Client::Trophy).to receive(:all_account_titles).and_return(psn_response)
    end

    context 'when no titles are already imported' do
      before do
        allow(TrophyList).to receive(:exists?).and_return(false)
      end

      it 'imports all trophies defined on the account' do
        expect(PSN::Client::Trophy).to receive(:all_account_titles)
        expect(PSN::Services::ImportPSNRelease).to receive(:import).twice
        expect(TrophyList).to receive(:find_by!).twice

        described_class.import(account.account_id)
      end
    end

    context 'when some titles are already imported' do
      before do
        allow(TrophyList).to receive(:exists?).with(comm_id: psn_response.first['npCommunicationId'])
                                              .and_return(false)
        allow(TrophyList).to receive(:exists?).with(comm_id: psn_response.second['npCommunicationId'])
                                              .and_return(true)
      end

      it 'imports all trophies defined on the account' do
        expect(PSN::Client::Trophy).to receive(:all_account_titles)
        expect(PSN::Services::ImportPSNRelease).to receive(:import)
        expect(TrophyList).to receive(:find_by!).twice

        described_class.import(account.account_id)
      end
    end
  end
end
