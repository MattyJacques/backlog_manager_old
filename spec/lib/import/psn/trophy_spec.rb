require 'rails_helper'

RSpec.describe Import::PSN::Trophy do
  describe '.title_trophy_list', :vcr do
    context 'when the service name is trophy' do
      it 'returns the trophy list for the PS3/PS4/PS Vita title' do
        result = described_class.title_trophy_list('NPWR00160_00', 'trophy')

        expect(result[0]['trophyId']).to_not be_nil
        expect(result[0]['trophyHidden']).to_not be_nil
        expect(result[0]['trophyType']).to_not be_nil
        expect(result[0]['trophyName']).to_not be_nil
        expect(result[0]['trophyDetail']).to_not be_nil
        expect(result[0]['trophyIconUrl']).to_not be_nil
        expect(result[0]['trophyGroupId']).to_not be_nil
      end
    end

    context 'when the service name is trophy2' do
      it 'returns the trophy list for the PS5 title' do
        result = described_class.title_trophy_list('NPWR22598_00', 'trophy2')

        expect(result[1]['trophyId']).to_not be_nil
        expect(result[1]['trophyHidden']).to_not be_nil
        expect(result[1]['trophyType']).to_not be_nil
        expect(result[1]['trophyName']).to_not be_nil
        expect(result[1]['trophyDetail']).to_not be_nil
        expect(result[1]['trophyIconUrl']).to_not be_nil
        expect(result[1]['trophyGroupId']).to_not be_nil
        expect(result[1]['trophyProgressTargetValue']).to_not be_nil
      end
    end
  end

  describe '.earned_trophies_for_title', :vcr do
    context 'when the title is a PS3, PS4 or PS Vita title' do
      it 'returns a list of earned trophies for a single title' do
        result = described_class.earned_trophies_for_title('NPWR00160_00', 'trophy', 'me')

        expect(result[0]['trophyId']).to_not be_nil
        expect(result[0]['trophyHidden']).to_not be_nil
        expect(result[0]['earned']).to_not be_nil
        expect(result[0]['trophyType']).to_not be_nil
        expect(result[0]['trophyRare']).to_not be_nil
        expect(result[0]['trophyEarnedRate']).to_not be_nil
        expect(result[1]['trophyId']).to_not be_nil
        expect(result[1]['trophyHidden']).to_not be_nil
        expect(result[1]['earned']).to_not be_nil
        expect(result[1]['earnedDateTime']).to_not be_nil
        expect(result[1]['trophyType']).to_not be_nil
        expect(result[1]['trophyRare']).to_not be_nil
        expect(result[1]['trophyEarnedRate']).to_not be_nil
      end
    end

    context 'when the title is a PS5 title' do
      it 'returns a list of earned trophies for a single PS5 title' do
        # TODO - Get a result which has an in progress trophy
        result = described_class.earned_trophies_for_title('NPWR22792_00', 'trophy2', '6588603711421927529')

        expect(result[0]['trophyId']).to_not be_nil
        expect(result[0]['trophyHidden']).to_not be_nil
        expect(result[0]['earned']).to_not be_nil
        expect(result[0]['trophyType']).to_not be_nil
        expect(result[0]['trophyRare']).to_not be_nil
        expect(result[0]['trophyEarnedRate']).to_not be_nil
        expect(result[1]['trophyId']).to_not be_nil
        expect(result[1]['trophyHidden']).to_not be_nil
        expect(result[1]['earned']).to_not be_nil
        expect(result[1]['earnedDateTime']).to_not be_nil
        expect(result[1]['trophyType']).to_not be_nil
        expect(result[1]['trophyRare']).to_not be_nil
        expect(result[1]['trophyEarnedRate']).to_not be_nil
      end
    end
  end

  describe '.all_titles', :vcr do
    it 'returns a list of titles synced to authenticated account' do
      result = described_class.all_titles

      expect(result[0][:name]).to_not be_nil
      expect(result[0][:platform]).to_not be_nil
      expect(result[0][:progress]).to_not be_nil
      expect(result[0][:communication_id]).to_not be_nil
      expect(result[0][:service_name]).to_not be_nil
    end
  end

  describe '.all_trophies', :vcr do
    it 'returns a list of all earned trophies for the authenticated account' do
      result = described_class.all_trophies

      expect(result[0]['trophyId']).to_not be_nil
      expect(result[0]['trophyHidden']).to_not be_nil
      expect(result[0]['earned']).to_not be_nil
      expect(result[0]['earnedDateTime']).to_not be_nil
      expect(result[0]['trophyType']).to_not be_nil
      expect(result[0]['trophyRare']).to_not be_nil
      expect(result[0]['trophyEarnedRate']).to_not be_nil
    end
  end

  describe '.trophy_streak', :vcr do
    it 'returns a list of dates that do not have a earned trophy associated' do
      result = described_class.trophy_streak

      expect(result.count).to be > 0
      expect(result[0]).to be_a(Date)
    end
  end
end