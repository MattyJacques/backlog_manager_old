require 'rails_helper'

RSpec.describe Import::PSN::API::Trophy do
  describe '.account_summary', :vcr do
    it 'returns account summary for authenticated account' do
      result = described_class.account_summary

      expect(result['accountId']).to_not be_nil
      expect(result['trophyLevel']).to_not be_nil
      expect(result['progress']).to_not be_nil
      expect(result['tier']).to_not be_nil
      expect(result['earnedTrophies']).to_not be_nil
      expect(result['earnedTrophies']['bronze']).to_not be_nil
      expect(result['earnedTrophies']['silver']).to_not be_nil
      expect(result['earnedTrophies']['gold']).to_not be_nil
      expect(result['earnedTrophies']['platinum']).to_not be_nil
    end
  end

  describe '.account_titles', :vcr do
    it 'returns a list of titles synced to authenticated account' do
      result = described_class.account_titles

      expect(result['trophyTitles']).to_not be_nil
      expect(result['trophyTitles'][0]['npServiceName']).to_not be_nil
      expect(result['trophyTitles'][0]['npCommunicationId']).to_not be_nil
      expect(result['trophyTitles'][0]['trophySetVersion']).to_not be_nil
      expect(result['trophyTitles'][0]['trophyTitleName']).to_not be_nil
      expect(result['trophyTitles'][0]['trophyTitleIconUrl']).to_not be_nil
      expect(result['trophyTitles'][0]['trophyTitlePlatform']).to_not be_nil
      expect(result['trophyTitles'][0]['hasTrophyGroups']).to_not be_nil
      expect(result['trophyTitles'][0]['definedTrophies']).to_not be_nil
      expect(result['trophyTitles'][0]['definedTrophies']['bronze']).to_not be_nil
      expect(result['trophyTitles'][0]['definedTrophies']['silver']).to_not be_nil
      expect(result['trophyTitles'][0]['definedTrophies']['gold']).to_not be_nil
      expect(result['trophyTitles'][0]['definedTrophies']['platinum']).to_not be_nil
      expect(result['trophyTitles'][0]['progress']).to_not be_nil
      expect(result['trophyTitles'][0]['earnedTrophies']).to_not be_nil
      expect(result['trophyTitles'][0]['earnedTrophies']['bronze']).to_not be_nil
      expect(result['trophyTitles'][0]['earnedTrophies']['silver']).to_not be_nil
      expect(result['trophyTitles'][0]['earnedTrophies']['gold']).to_not be_nil
      expect(result['trophyTitles'][0]['earnedTrophies']['platinum']).to_not be_nil
      expect(result['trophyTitles'][0]['hiddenFlag']).to_not be_nil
      expect(result['trophyTitles'][0]['lastUpdatedDateTime']).to_not be_nil
      expect(result['totalItemCount']).to_not be_nil
    end

    it 'returns a list of titles offset by given amount' do
      expected = described_class.account_titles['trophyTitles']
      result = described_class.account_titles(offset: 100)

      expect(result['trophyTitles'][0]).to eq(expected[100])
    end

    it 'returns a list of titles limited by the given value' do
      result = described_class.account_titles(limit: 10)

      expect(result['trophyTitles'].count).to eq(10)
    end
  end

  describe '.title_trophy_list', :vcr do
    context 'when there is no account ID provided' do
      context 'when the title is a PS3, PS4 or PS Vita title' do
        it 'returns a list of trophies for a single title' do
          result = described_class.title_trophy_list('NPWR00160_00')

          expect(result['trophySetVersion']).to_not be_nil
          expect(result['hasTrophyGroups']).to_not be_nil
          expect(result['trophies']).to_not be_nil
          expect(result['trophies'][0]['trophyId']).to_not be_nil
          expect(result['trophies'][0]['trophyHidden']).to_not be_nil
          expect(result['trophies'][0]['trophyType']).to_not be_nil
          expect(result['trophies'][0]['trophyName']).to_not be_nil
          expect(result['trophies'][0]['trophyDetail']).to_not be_nil
          expect(result['trophies'][0]['trophyIconUrl']).to_not be_nil
          expect(result['trophies'][0]['trophyGroupId']).to_not be_nil
          expect(result['totalItemCount']).to_not be_nil
        end
      end

      context 'when the title is a PS5 title' do
        it 'returns a list of trophies for a single title' do
          result = described_class.title_trophy_list('NPWR22598_00', 'trophy2')

          expect(result['trophySetVersion']).to_not be_nil
          expect(result['hasTrophyGroups']).to_not be_nil
          expect(result['trophies']).to_not be_nil
          expect(result['trophies'][1]['trophyId']).to_not be_nil
          expect(result['trophies'][1]['trophyHidden']).to_not be_nil
          expect(result['trophies'][1]['trophyType']).to_not be_nil
          expect(result['trophies'][1]['trophyName']).to_not be_nil
          expect(result['trophies'][1]['trophyDetail']).to_not be_nil
          expect(result['trophies'][1]['trophyIconUrl']).to_not be_nil
          expect(result['trophies'][1]['trophyGroupId']).to_not be_nil
          expect(result['trophies'][1]['trophyProgressTargetValue']).to_not be_nil
          expect(result['totalItemCount']).to_not be_nil
        end
      end
    end

    context 'when an account ID is provided' do
      context 'when the title is a PS3, PS4 or PS Vita title' do
        it 'returns a list of earned trophies for a single title' do
          result = described_class.title_trophy_list('NPWR00160_00', 'trophy', 'me')

          expect(result['trophySetVersion']).to_not be_nil
          expect(result['hasTrophyGroups']).to_not be_nil
          expect(result['lastUpdatedDateTime']).to_not be_nil
          expect(result['trophies']).to_not be_nil
          expect(result['trophies'][0]['trophyId']).to_not be_nil
          expect(result['trophies'][0]['trophyHidden']).to_not be_nil
          expect(result['trophies'][0]['earned']).to_not be_nil
          expect(result['trophies'][0]['trophyType']).to_not be_nil
          expect(result['trophies'][0]['trophyRare']).to_not be_nil
          expect(result['trophies'][0]['trophyEarnedRate']).to_not be_nil
          expect(result['trophies'][1]['trophyId']).to_not be_nil
          expect(result['trophies'][1]['trophyHidden']).to_not be_nil
          expect(result['trophies'][1]['earned']).to_not be_nil
          expect(result['trophies'][1]['earnedDateTime']).to_not be_nil
          expect(result['trophies'][1]['trophyType']).to_not be_nil
          expect(result['trophies'][1]['trophyRare']).to_not be_nil
          expect(result['trophies'][1]['trophyEarnedRate']).to_not be_nil
          expect(result['rarestTrophies']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyId']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyHidden']).to_not be_nil
          expect(result['rarestTrophies'][0]['earned']).to_not be_nil
          expect(result['rarestTrophies'][0]['earnedDateTime']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyType']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyRare']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyEarnedRate']).to_not be_nil
          expect(result['totalItemCount']).to_not be_nil
        end
      end

      context 'when the title is a PS5 title' do
        it 'returns a list of earned trophies for a single title' do
          # TODO - Get a result which has an in progress trophy
          result = described_class.title_trophy_list('NPWR22792_00', 'trophy2', '6588603711421927529')

          expect(result['trophySetVersion']).to_not be_nil
          expect(result['hasTrophyGroups']).to_not be_nil
          expect(result['lastUpdatedDateTime']).to_not be_nil
          expect(result['trophies']).to_not be_nil
          expect(result['trophies'][0]['trophyId']).to_not be_nil
          expect(result['trophies'][0]['trophyHidden']).to_not be_nil
          expect(result['trophies'][0]['earned']).to_not be_nil
          expect(result['trophies'][0]['trophyType']).to_not be_nil
          expect(result['trophies'][0]['trophyRare']).to_not be_nil
          expect(result['trophies'][0]['trophyEarnedRate']).to_not be_nil
          expect(result['trophies'][1]['trophyId']).to_not be_nil
          expect(result['trophies'][1]['trophyHidden']).to_not be_nil
          expect(result['trophies'][1]['earned']).to_not be_nil
          expect(result['trophies'][1]['earnedDateTime']).to_not be_nil
          expect(result['trophies'][1]['trophyType']).to_not be_nil
          expect(result['trophies'][1]['trophyRare']).to_not be_nil
          expect(result['trophies'][1]['trophyEarnedRate']).to_not be_nil
          expect(result['rarestTrophies']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyId']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyHidden']).to_not be_nil
          expect(result['rarestTrophies'][0]['earned']).to_not be_nil
          expect(result['rarestTrophies'][0]['earnedDateTime']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyType']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyRare']).to_not be_nil
          expect(result['rarestTrophies'][0]['trophyEarnedRate']).to_not be_nil
          expect(result['totalItemCount']).to_not be_nil
        end
      end
    end
  end

  describe '.account_summary_for_title', :vcr do
    it 'returns a summary of the earned status for a title' do
      result = described_class.account_summary_for_title('6588603711421927529', ['PPSA04874_00'])

      expect(result['titles']).to_not be_nil
      expect(result['titles'][0]).to_not be_nil
      expect(result['titles'][0]['npTitleId']).to_not be_nil
      expect(result['titles'][0]['trophyTitles']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['npServiceName']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['npCommunicationId']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['trophyTitleName']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['trophyTitleIconUrl']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['hasTrophyGroups']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyId']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyHidden']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyType']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyName']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyDetail']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyIconUrl']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyRare']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['trophyEarnedRate']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['earned']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['rarestTrophies'][0]['earnedDateTime']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['progress']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['earnedTrophies']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['earnedTrophies']['bronze']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['earnedTrophies']['silver']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['earnedTrophies']['gold']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['earnedTrophies']['platinum']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['definedTrophies']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['definedTrophies']['bronze']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['definedTrophies']['silver']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['definedTrophies']['gold']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['definedTrophies']['platinum']).to_not be_nil
      expect(result['titles'][0]['trophyTitles'][0]['lastUpdatedDateTime']).to_not be_nil
    end
  end

  describe '.trophy', :vcr do
    it 'returns the general data for a specific trophy' do
      result = described_class.trophy('NPWR22792_00', 0, 'trophy2')

      expect(result['trophySetVersion']).to_not be_nil
      expect(result['trophyId']).to_not be_nil
      expect(result['trophyHidden']).to_not be_nil
      expect(result['trophyType']).to_not be_nil
      expect(result['trophyName']).to_not be_nil
      expect(result['trophyDetail']).to_not be_nil
      expect(result['trophyIconUrl']).to_not be_nil
      expect(result['trophyGroupId']).to_not be_nil
      expect(result['trophyRewardName']).to_not be_nil
      expect(result['trophyRewardImageUrl']).to_not be_nil
    end

    it 'returns the earned data for the specified account for a specific trophy' do
      result = described_class.trophy('NPWR22792_00', 1, 'trophy2', '6588603711421927529')

      expect(result['trophyId']).to_not be_nil
      expect(result['earned']).to_not be_nil
      expect(result['earnedDateTime']).to_not be_nil
      expect(result['trophyRare']).to_not be_nil
      expect(result['trophyEarnedRate']).to_not be_nil
    end
  end

  describe '.trophy_groups', :vcr do
    it 'returns the data of trophy groups for a title' do
      result = described_class.trophy_groups('NPWR22598_00', 'trophy2')

      expect(result['trophySetVersion']).to_not be_nil
      expect(result['trophyTitleName']).to_not be_nil
      expect(result['trophyTitleIconUrl']).to_not be_nil
      expect(result['trophyTitlePlatform']).to_not be_nil
      expect(result['definedTrophies']).to_not be_nil
      expect(result['definedTrophies']['bronze']).to_not be_nil
      expect(result['definedTrophies']['silver']).to_not be_nil
      expect(result['definedTrophies']['gold']).to_not be_nil
      expect(result['definedTrophies']['platinum']).to_not be_nil
      expect(result['trophyGroups']).to_not be_nil
      expect(result['trophyGroups'].count).to be > 0
      expect(result['trophyGroups'][0]['trophyGroupId']).to_not be_nil
      expect(result['trophyGroups'][0]['trophyGroupName']).to_not be_nil
      expect(result['trophyGroups'][0]['trophyGroupIconUrl']).to_not be_nil
      expect(result['trophyGroups'][0]['definedTrophies']).to_not be_nil
      expect(result['trophyGroups'][0]['definedTrophies']['bronze']).to_not be_nil
      expect(result['trophyGroups'][0]['definedTrophies']['silver']).to_not be_nil
      expect(result['trophyGroups'][0]['definedTrophies']['gold']).to_not be_nil
      expect(result['trophyGroups'][0]['definedTrophies']['platinum']).to_not be_nil
    end

    it 'returns the earned data for the trophy groups for a title' do
      result = described_class.trophy_groups('NPWR22598_00', 'trophy2', '6588603711421927529')

      expect(result['trophySetVersion']).to_not be_nil
      expect(result['hiddenFlag']).to_not be_nil
      expect(result['progress']).to_not be_nil
      expect(result['earnedTrophies']).to_not be_nil
      expect(result['earnedTrophies']['bronze']).to_not be_nil
      expect(result['earnedTrophies']['silver']).to_not be_nil
      expect(result['earnedTrophies']['gold']).to_not be_nil
      expect(result['earnedTrophies']['platinum']).to_not be_nil
      expect(result['lastUpdatedDateTime']).to_not be_nil
      expect(result['trophyGroups']).to_not be_nil
      expect(result['trophyGroups'].count).to be > 0
      expect(result['trophyGroups'][0]['trophyGroupId']).to_not be_nil
      expect(result['trophyGroups'][0]['progress']).to_not be_nil
      expect(result['trophyGroups'][0]['earnedTrophies']).to_not be_nil
      expect(result['trophyGroups'][0]['earnedTrophies']['bronze']).to_not be_nil
      expect(result['trophyGroups'][0]['earnedTrophies']['silver']).to_not be_nil
      expect(result['trophyGroups'][0]['earnedTrophies']['gold']).to_not be_nil
      expect(result['trophyGroups'][0]['earnedTrophies']['platinum']).to_not be_nil
      expect(result['trophyGroups'][0]['lastUpdatedDateTime']).to_not be_nil
    end
  end
end