# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::ImportTitleTrophyList do
  describe '.import' do
    let(:trophy_list) { build(:trophy_list) }
    let(:trophy_list_response) do
      {
        'trophySetVersion' => '01.00',
        'hasTrophyGroups' => true,
        'trophies' => Array.new(70) do |i|
          {
            'trophyId' => i,
            'trophyHidden' => false,
            'trophyType' => 'bronze',
            'trophyName' => "Trophy #{i}",
            'trophyDetail' => 'Test trophy description',
            'trophyIconUrl' => 'http://example.com/trophy.png',
            'trophyGroupId' => 'default'
          }
        end,
        'totalItemCount' => 70
      }
    end

    before do
      allow(TrophyList).to receive(:create).and_return(trophy_list)
      allow(PSN::Client::Trophy).to receive(:title_trophy_list).and_return(trophy_list_response)
    end

    it 'imports all trophies for the title' do
      expect(TrophyList).to receive(:create)
      expect(Trophy).to receive(:create).exactly(70).times

      described_class.import('LittleBigPlanet™', 'Play, Create, Share', 'NPWR00160_00', 'trophy', 'trophyicons.com')
    end
  end
end
