# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::UpdateAccountEarnedTrophies do
  describe '.update' do
    let(:account) { build(:psn_account, :account_id) }
    let(:all_titles_response) do
      [
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
          'lastUpdatedDateTime' => last_update_timestamp
        }
      ]
    end
    let(:np_comm_id) { 'NPWR00117_00' }
    let(:last_update_timestamp) { DateTime.now.to_s }
    let(:earned_summary) do
      {
        'earnedTrophies' => { 'bronze' => 50, 'silver' => 30, 'gold' => 20, 'platinum' => 1 }
      }
    end
    let(:earned_trophy_rel) { instance_double(ActiveRecord::Relation, count: 101) }
    let(:account_list_rel) { instance_double(ActiveRecord::Relation, count: 5) }
    let(:psn_title_count) { 5 }

    before do
      allow(PSNAccount).to receive(:find_by!).with(account_id: account.account_id).and_return(account)
      allow(PSN::Client::Trophy).to receive(:all_account_titles).and_return(all_titles_response)
      allow(PSN::Client::Trophy).to receive(:account_summary).and_return(earned_summary)
      allow(PSN::Client::Trophy).to receive(:account_title_count).and_return(psn_title_count)
      allow(account).to receive(:earned_trophies).and_return(earned_trophy_rel)
      allow(account).to receive(:account_trophy_lists).and_return(account_list_rel)
    end

    context 'when trophy count is the same' do
      context 'when trophy count and title count are the same' do
        it 'does not update the account' do
          expect(PSN::Client::Trophy).not_to receive(:all_account_titles)
          expect(account).not_to receive(:update)
          expect(PSN::Services::UpdateAccountTitle).not_to receive(:update)

          described_class.update(account.account_id)
        end
      end

      context 'when title count has changed' do
        let(:psn_title_count) { 7 }

        it 'updates the account' do
          expect(PSN::Client::Trophy).to receive(:all_account_titles)
          expect(account).to receive(:update!).with(earned_bronze: earned_summary['earnedTrophies']['bronze'],
                                                    earned_silver: earned_summary['earnedTrophies']['silver'],
                                                    earned_gold: earned_summary['earnedTrophies']['gold'],
                                                    earned_platinum: earned_summary['earnedTrophies']['platinum'])
          expect(PSN::Services::UpdateAccountTitle).to receive(:update)

          described_class.update(account.account_id)
        end
      end
    end

    context 'when trophy count has changed' do
      let(:earned_summary) do
        {
          'earnedTrophies' => { 'bronze' => 100, 'silver' => 50, 'gold' => 40, 'platinum' => 2 }
        }
      end

      it 'updates the account' do
        expect(PSN::Client::Trophy).to receive(:all_account_titles)
        expect(account).to receive(:update!).with(earned_bronze: earned_summary['earnedTrophies']['bronze'],
                                                  earned_silver: earned_summary['earnedTrophies']['silver'],
                                                  earned_gold: earned_summary['earnedTrophies']['gold'],
                                                  earned_platinum: earned_summary['earnedTrophies']['platinum'])
        expect(PSN::Services::UpdateAccountTitle).to receive(:update)

        described_class.update(account.account_id)
      end
    end
  end
end
