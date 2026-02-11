# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::UpdateAccountTitle do
  describe '.update' do
    let(:account) { build(:psn_account, :account_id) }
    let(:title) do
      {
        'npServiceName' => 'trophy',
        'npCommunicationId' => np_comm_id,
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
        'lastUpdatedDateTime' => last_update_timestamp.to_s
      }
    end
    let(:np_comm_id) { 'NPWR00117_00' }
    let(:last_update_timestamp) { DateTime.now }
    let(:trophy_list) { build(:trophy_list, trophy_count: 1) }
    let(:account_trophy_list) { build(:account_trophy_list, psn_updated_at: 1.minute.ago) }
    let(:trophy) { trophy_list.trophies.first }
    let(:earned_data_response) do
      {
        'trophySetVersion' => '01.12',
        'hasTrophyGroups' => false,
        'lastUpdatedDateTime' => '2008-07-16T10:59:08Z',
        'trophies' => Array.new(17) do |i|
          {
            'trophyId' => i,
            'trophyHidden' => false,
            'earned' => true,
            'earnedDateTime' => "2008-07-#{format('%02d', i + 1)}T13:16:12Z",
            'trophyType' => 'bronze',
            'trophyRare' => 2,
            'trophyEarnedRate' => '38.6'
          }
        end,
        'rarestTrophies' => [],
        'totalItemCount' => 17
      }
    end

    before do
      allow(TrophyList).to receive(:find_by!).with(comm_id: np_comm_id).and_return(trophy_list)
      allow(AccountTrophyList).to receive(:find_or_initialize_by).with(psn_account: account, trophy_list:)
                                                                 .and_return(account_trophy_list)
      allow(account_trophy_list).to receive(:update!)
      allow(trophy_list.trophies).to receive(:find_by!).and_return(trophy)
      allow(PSN::Client::Trophy).to receive(:title_trophy_list).and_return(earned_data_response)
    end

    context 'when all trophies are new' do
      it 'creates records for all trophies' do
        expect(EarnedTrophy).to receive(:create!).exactly(17).times
        expect(account_trophy_list).to receive(:update!).with(earned_bronze: title['earnedTrophies']['bronze'],
                                                              earned_silver: title['earnedTrophies']['silver'],
                                                              earned_gold: title['earnedTrophies']['gold'],
                                                              earned_platinum: title['earnedTrophies']['platinum'],
                                                              psn_updated_at: last_update_timestamp)

        described_class.update(account, title)
      end
    end

    context 'when title has not been updated on psn' do
      let(:account_trophy_list) { build(:account_trophy_list, psn_updated_at: DateTime.tomorrow) }

      it 'does not import/update any trophies' do
        expect(EarnedTrophy).not_to receive(:create!)
        expect_any_instance_of(EarnedTrophy).not_to receive(:update!)
        expect(account_trophy_list).not_to receive(:update!)

        described_class.update(account, title)
      end
    end

    context 'when a trophy timestamp has been updated to earlier time' do
      let(:account_trophy_list) { build(:account_trophy_list, psn_updated_at: DateTime.yesterday) }
      let(:earned_trophy) { build(:earned_trophy) }

      before do
        allow(account_trophy_list.earned_trophies).to receive(:find_by!).and_return(earned_trophy)
        allow(account_trophy_list.earned_trophies).to receive(:exists?).with(trophy:, timestamp: anything)
                                                                       .and_return(false)
        allow(account_trophy_list.earned_trophies).to receive(:exists?).with(trophy:).and_return(true)
      end

      it 'updates the trophy timestamp' do
        expect(earned_trophy).to receive(:update!).with(timestamp: anything).exactly(17).times
        expect(account_trophy_list).to receive(:update!).with(earned_bronze: title['earnedTrophies']['bronze'],
                                                              earned_silver: title['earnedTrophies']['silver'],
                                                              earned_gold: title['earnedTrophies']['gold'],
                                                              earned_platinum: title['earnedTrophies']['platinum'],
                                                              psn_updated_at: last_update_timestamp)

        described_class.update(account, title)
      end
    end

    context 'when a trophy is earned but missing a timestamp' do
      let(:earned_trophy) { build(:earned_trophy) }
      let(:earned_data_response) do
        {
          'trophySetVersion' => '01.12',
          'hasTrophyGroups' => false,
          'lastUpdatedDateTime' => '2008-07-16T10:59:08Z',
          'trophies' => [
            {
              'trophyId' => 0,
              'trophyHidden' => false,
              'earned' => true,
              'earnedDateTime' => '2008-07-02T13:16:12Z',
              'trophyType' => 'bronze',
              'trophyRare' => 2,
              'trophyEarnedRate' => '38.6'
            },
            {
              'trophyId' => 1,
              'trophyHidden' => false,
              'earned' => true,
              'trophyType' => 'bronze',
              'trophyRare' => 2,
              'trophyEarnedRate' => '47.3'
            },
            {
              'trophyId' => 2,
              'trophyHidden' => false,
              'earned' => false,
              'trophyType' => 'bronze',
              'trophyRare' => 2,
              'trophyEarnedRate' => '23.7'
            }
          ],
          'rarestTrophies' => [
            {
              'trophyId' => 0,
              'trophyHidden' => false,
              'earned' => true,
              'earnedDateTime' => '2008-07-02T13:16:12Z',
              'trophyType' => 'bronze',
              'trophyRare' => 2,
              'trophyEarnedRate' => '38.6'
            }
          ],
          'totalItemCount' => 17
        }
      end

      before do
        allow(account_trophy_list.earned_trophies).to receive(:find_by!).and_return(earned_trophy)
        allow(account_trophy_list.earned_trophies).to receive(:exists?).with(trophy:, timestamp: anything)
                                                                       .and_return(false)
        allow(account_trophy_list.earned_trophies).to receive(:exists?).with(trophy:).and_return(true)
      end

      it 'creates the earned trophy with a nil timestamp' do
        expect(earned_trophy).to receive(:update!).with(timestamp: '2008-07-02T13:16:12Z')
        expect(earned_trophy).to receive(:update!).with(timestamp: nil)
        expect(account_trophy_list).to receive(:update!).with(earned_bronze: title['earnedTrophies']['bronze'],
                                                              earned_silver: title['earnedTrophies']['silver'],
                                                              earned_gold: title['earnedTrophies']['gold'],
                                                              earned_platinum: title['earnedTrophies']['platinum'],
                                                              psn_updated_at: last_update_timestamp)

        described_class.update(account, title)
      end
    end
  end
end
