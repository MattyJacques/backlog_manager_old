# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::Trophy do
  let(:account_id) { '6796840136244039860' }

  describe '.account_summary' do
    let(:expected_keys) do
      %w[accountId trophyLevel progress tier earnedTrophies]
    end
    let(:response_body) do
      {
        'accountId' => account_id,
        'trophyLevel' => 500,
        'progress' => 50,
        'tier' => 10,
        'earnedTrophies' => { 'bronze' => 1000, 'silver' => 500, 'gold' => 200, 'platinum' => 50 }
      }
    end

    before do
      stub_psn_account_summary(account_id, response_body)
    end

    it 'returns account summary for given account' do
      response = described_class.account_summary(account_id)

      expect(response.values_at(*expected_keys)).not_to include(nil)
    end
  end

  describe '.account_title_count' do
    let(:psn_response) do
      {
        'trophyTitles' => [
          {
            'npServiceName' => 'trophy',
            'npCommunicationId' => 'NPWR06221_00',
            'trophySetVersion' => '01.05',
            'trophyTitleName' => 'Grand Theft Auto V',
            'trophyTitleDetail' => 'Grand Theft Auto V',
            'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR06221_00_00943B71B23B3A5D98EB6CA419684E0F0A07FA8707/A3E52C438318CCEC6346EB2A31DBF31164A95A25.PNG',
            'trophyTitlePlatform' => 'PS4',
            'hasTrophyGroups' => true,
            'definedTrophies' => { 'bronze' => 59, 'silver' => 15, 'gold' => 3, 'platinum' => 1 },
            'progress' => 2,
            'earnedTrophies' => { 'bronze' => 3, 'silver' => 0, 'gold' => 0, 'platinum' => 0 },
            'hiddenFlag' => false,
            'lastUpdatedDateTime' => '2023-06-14T11:07:58Z'
          }
        ],
        'nextOffset' => 1,
        'totalItemCount' => 114
      }
    end

    before do
      allow(described_class).to receive(:account_titles).with(account_id, limit: 1).and_return(psn_response)
    end

    it 'returns the title count for the PSN account' do
      expect(described_class.account_title_count(account_id)).to be(114)
    end
  end

  describe '.account_titles' do
    let(:expected_result) do
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
      }
    end
    let(:titles_response) do
      {
        'trophyTitles' => [expected_result],
        'totalItemCount' => 8381
      }
    end

    before do
      stub_psn_account_titles(account_id, titles_response)
    end

    it 'returns a list of titles synced to account' do
      response = described_class.account_titles(account_id, offset: 8380, limit: 800)

      expect(response['trophyTitles'].last).to eql(expected_result)
      expect(response['totalItemCount']).not_to be_nil
    end

    it 'returns a list of titles offset by given amount' do
      response = described_class.account_titles(account_id, offset: 100)

      expect(response['trophyTitles']).not_to be_nil
    end

    it 'returns a list of titles limited by the given value' do
      response = described_class.account_titles(account_id, limit: 10)

      expect(response['trophyTitles']).not_to be_nil
    end
  end

  describe '.all_account_titles' do
    let(:expected_result) do
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
      }
    end
    let(:titles) { Array.new(150) { expected_result } }

    context 'when limit is lower than total number of titles' do
      before do
        stub_const('PSN::Trophy::TITLES_LIMIT', 100)
        allow(described_class).to receive(:account_titles).and_return(
          { 'trophyTitles' => titles[0..99], 'totalItemCount' => 150, 'nextOffset' => 100 },
          { 'trophyTitles' => titles[100..149], 'totalItemCount' => 150 }
        )
      end

      it 'returns a list of titles synced to given account' do
        result = described_class.all_account_titles(account_id)

        expect(result.last).to eql(expected_result)
        expect(result.count).to be > 100
      end
    end

    context 'when limit is higher than total number of titles' do
      before do
        allow(described_class).to receive(:account_titles).and_return(
          { 'trophyTitles' => titles, 'totalItemCount' => 150 }
        )
      end

      it 'returns a list of titles synced to given account' do
        result = described_class.all_account_titles(account_id)

        expect(result.last).to eql(expected_result)
        expect(result.count).to be > 100
      end
    end
  end

  describe '.title_trophy_list' do
    context 'when there is no account ID provided' do
      let(:expected_keys) do
        %w[trophySetVersion hasTrophyGroups trophies totalItemCount]
      end

      context 'when the title is a PS3, PS4 or PS Vita title' do
        let(:expected_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'trophyType' => 'platinum',
            'trophyName' => '100% Complete',
            'trophyDetail' => 'Earn all LittleBigPlanet™ trophies to unlock this platinum trophy',
            'trophyIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00160_00_008E284646AFE80C3D45BBA5D6763ADDF683823CD4/7CEBBF51CFF811EDCBD664BEEF1CAACC46A2F406.PNG',
            'trophyGroupId' => 'default'
          }
        end
        let(:trophy_list_response) do
          {
            'trophySetVersion' => '01.00',
            'hasTrophyGroups' => true,
            'trophies' => [expected_response],
            'totalItemCount' => 70
          }
        end

        before do
          stub_psn_title_trophy_list('NPWR00160_00', trophy_list_response)
        end

        it 'returns a list of trophies for a single title' do
          response = described_class.title_trophy_list('NPWR00160_00')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_response)
        end
      end

      context 'when the title is a PS5 title' do
        let(:expected_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'trophyType' => 'platinum',
            'trophyName' => 'General of the Army',
            'trophyDetail' => 'Unlock all Trophies',
            'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22598_00/fd99baeb-9bc5-4a4d-a1e6-ade16e534e04.png',
            'trophyGroupId' => 'default'
          }
        end
        let(:trophy_list_response) do
          {
            'trophySetVersion' => '01.00',
            'hasTrophyGroups' => false,
            'trophies' => [expected_response],
            'totalItemCount' => 1
          }
        end

        before do
          stub_psn_title_trophy_list('NPWR22598_00', trophy_list_response)
        end

        it 'returns a list of trophies for a single title' do
          response = described_class.title_trophy_list('NPWR22598_00', 'trophy2')

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_response)
        end
      end
    end

    context 'when an account ID is provided' do
      let(:expected_keys) do
        %w[trophySetVersion hasTrophyGroups lastUpdatedDateTime trophies rarestTrophies totalItemCount]
      end

      context 'when the title is a PS3, PS4 or PS Vita title' do
        let(:expected_unearned_response) do
          {
            'trophyId' => 59,
            'trophyHidden' => false,
            'earned' => false,
            'trophyType' => 'silver',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.4'
          }
        end
        let(:expected_earned_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'earned' => true,
            'earnedDateTime' => '2009-05-29T21:01:55Z',
            'trophyType' => 'platinum',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.4'
          }
        end
        let(:trophy_list_response) do
          trophies = Array.new(60) { |i| { 'trophyId' => i, 'earned' => false } }
          trophies[0] = expected_earned_response
          trophies[59] = expected_unearned_response
          {
            'trophySetVersion' => '01.00',
            'hasTrophyGroups' => true,
            'lastUpdatedDateTime' => '2009-05-29T21:01:55Z',
            'trophies' => trophies,
            'rarestTrophies' => [],
            'totalItemCount' => 60
          }
        end

        before do
          stub_psn_title_trophy_list('NPWR00160_00', trophy_list_response, account_id:)
        end

        it 'returns a list of earned trophies for a single title' do
          response = described_class.title_trophy_list('NPWR00160_00', 'trophy', account_id)

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][59]).to eql(expected_unearned_response)
          expect(response['trophies'][0]).to eql(expected_earned_response)
        end
      end

      context 'when the title is a PS5 title' do
        let(:expected_unearned_response) do
          {
            'trophyId' => 0,
            'trophyHidden' => false,
            'earned' => false,
            'trophyType' => 'platinum',
            'trophyRare' => 0,
            'trophyEarnedRate' => '0.1'
          }
        end
        let(:expected_earned_response) do
          {
            'trophyId' => 1,
            'trophyHidden' => false,
            'earned' => true,
            'earnedDateTime' => '2021-02-02T22:21:43Z',
            'trophyType' => 'bronze',
            'trophyRare' => 1,
            'trophyEarnedRate' => '5.9'
          }
        end
        let(:trophy_list_response) do
          {
            'trophySetVersion' => '01.00',
            'hasTrophyGroups' => false,
            'lastUpdatedDateTime' => '2021-02-02T22:21:43Z',
            'trophies' => [expected_unearned_response, expected_earned_response],
            'rarestTrophies' => [],
            'totalItemCount' => 2
          }
        end

        before do
          stub_psn_title_trophy_list('NPWR22792_00', trophy_list_response, account_id:)
        end

        it 'returns a list of earned trophies for a single title' do
          response = described_class.title_trophy_list('NPWR22792_00', 'trophy2', account_id)

          expect(response.values_at(*expected_keys)).not_to include(nil)
          expect(response['trophies'][0]).to eql(expected_unearned_response)
          expect(response['trophies'][1]).to eql(expected_earned_response)
        end
      end
    end
  end

  describe '.account_summary_for_title' do
    let(:expected_response) do
      {
        'titles' =>
        [
          {
            'npTitleId' => 'PPSA07642_00',
            'trophyTitles' =>
            [
              {
                'npServiceName' => 'trophy2',
                'npCommunicationId' => 'NPWR26546_00',
                'trophyTitleName' => 'The Last of Us™ Part I',
                'trophyTitleIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR26546_00/dea7e1e5-f166-40a8-bc45-87966932a478.png',
                'hasTrophyGroups' => false,
                'rarestTrophies' => [
                  {
                    'trophyId' => 0,
                    'trophyHidden' => false,
                    'trophyType' => 'platinum',
                    'trophyName' => 'It Can\'t Be For Nothing',
                    'trophyDetail' => 'Collect all trophies',
                    'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR26546_00/c5e3c1f0-12dc-40f1-8fe7-0514dc034007.png',
                    'trophyRare' => 1,
                    'trophyEarnedRate' => '6.2',
                    'earned' => true,
                    'earnedDateTime' => '2022-10-02T17:34:14Z'
                  }
                ],
                'progress' => 100,
                'earnedTrophies' => { 'bronze' => 14, 'silver' => 7, 'gold' => 7, 'platinum' => 1 },
                'definedTrophies' => { 'bronze' => 14, 'silver' => 7, 'gold' => 7, 'platinum' => 1 },
                'lastUpdatedDateTime' => '2022-10-02T17:34:14Z'
              }
            ]
          }
        ]
      }
    end

    before do
      stub_psn_account_summary_for_title(account_id, expected_response)
    end

    it 'returns a summary of the earned status for a title' do
      response = described_class.account_summary_for_title(account_id, ['PPSA07642_00'])

      expect(response.to_hash).to eql(expected_response)
    end
  end

  describe '.trophy' do
    let(:expected_response) do
      {
        'trophySetVersion' => '01.00',
        'trophyId' => 0,
        'trophyHidden' => false,
        'trophyType' => 'platinum',
        'trophyName' => 'Hall of Fame',
        'trophyDetail' => 'Unlock all Destruction AllStars Trophies',
        'trophyIconUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22792_00/22495328-c5ad-4cf1-be7c-e8be615a6c5b.png',
        'trophyGroupId' => 'default',
        'trophyRewardName' => 'Profile Banner',
        'trophyRewardImageUrl' => 'https://psnobj.prod.dl.playstation.net/psnobj/NPWR22792_00/3433d6c0-fa6e-43e1-a557-c4d71f7c2400.png'
      }
    end
    let(:expected_earned_response) do
      {
        'trophyId' => 1,
        'earned' => true,
        'earnedDateTime' => '2021-02-02T22:21:43Z',
        'trophyRare' => 1,
        'trophyEarnedRate' => '5.9'
      }
    end

    before do
      stub_psn_trophy('NPWR22792_00', 0, expected_response)
      stub_psn_trophy('NPWR22792_00', 1, expected_earned_response, account_id:)
    end

    it 'returns the general data for a specific trophy' do
      response = described_class.trophy('NPWR22792_00', 0, 'trophy2')

      expect(response.to_hash).to eql(expected_response)
    end

    it 'returns the earned data for the specified account for a specific trophy' do
      response = described_class.trophy('NPWR22792_00', 1, 'trophy2', account_id)

      expect(response.to_hash).to eql(expected_earned_response)
    end
  end

  describe '.trophy_groups' do
    let(:expected_response) do
      {
        'trophySetVersion' => '01.01',
        'trophyTitleName' => 'Mushroom Wars',
        'trophyTitleDetail' => 'Mushroom Wars Trophies',
        'trophyTitleIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/5D95EF11A55642F78D0509BDB3C106429E23380A.PNG',
        'trophyTitlePlatform' => 'PS3',
        'definedTrophies' => { 'bronze' => 18, 'silver' => 5, 'gold' => 0, 'platinum' => 0 },
        'trophyGroups' => [
          {
            'trophyGroupId' => 'default',
            'trophyGroupName' => 'Mushroom Wars',
            'trophyGroupDetail' => 'Mushroom Wars Trophies',
            'trophyGroupIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/5D95EF11A55642F78D0509BDB3C106429E23380A.PNG',
            'definedTrophies' => { 'bronze' => 15, 'silver' => 3, 'gold' => 0, 'platinum' => 0 }
          },
          {
            'trophyGroupId' => '001',
            'trophyGroupName' => 'Mushroom Wars Online',
            'trophyGroupDetail' => 'Mushroom Wars Online Trophies',
            'trophyGroupIconUrl' => 'https://image.api.playstation.com/trophy/np/NPWR00694_00_003E80EDD2CA0E8B4023DC35B228F5663CE7F2E920/771646BE851996A1E883BEF6ECF19C55DDF1A22C.PNG',
            'definedTrophies' => { 'bronze' => 3, 'silver' => 2, 'gold' => 0, 'platinum' => 0 }
          }
        ]
      }
    end
    let(:expected_earned_response) do
      {
        'trophySetVersion' => '01.01',
        'hiddenFlag' => false,
        'progress' => 10,
        'earnedTrophies' => { 'bronze' => 3, 'silver' => 0, 'gold' => 0, 'platinum' => 0 },
        'lastUpdatedDateTime' => '2011-10-15T13:30:30Z',
        'trophyGroups' => [
          {
            'trophyGroupId' => 'default',
            'progress' => 14,
            'earnedTrophies' => { 'bronze' => 3, 'silver' => 0, 'gold' => 0, 'platinum' => 0 },
            'lastUpdatedDateTime' => '2011-10-15T11:34:44Z'
          },
          {
            'trophyGroupId' => '001',
            'progress' => 0,
            'earnedTrophies' => { 'bronze' => 0, 'silver' => 0, 'gold' => 0, 'platinum' => 0 }
          }
        ]
      }
    end

    before do
      stub_psn_trophy_groups('NPWR00694_00', expected_response)
      stub_psn_trophy_groups('NPWR00694_00', expected_earned_response, account_id:)
    end

    it 'returns the data of trophy groups for a title' do
      response = described_class.trophy_groups('NPWR00694_00', 'trophy')

      expect(response.to_hash).to eql(expected_response)
    end

    it 'returns the earned data for the trophy groups for a title' do
      response = described_class.trophy_groups('NPWR00694_00', 'trophy', account_id)

      expect(response.to_hash).to eql(expected_earned_response)
    end
  end
end
