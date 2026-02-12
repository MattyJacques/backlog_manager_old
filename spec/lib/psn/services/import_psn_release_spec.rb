# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Services::ImportPSNRelease do
  describe '.import' do
    let(:game_name) { 'LittleBigPlanet™' }
    let(:game) { build(:game) }
    let(:release) { build(:release) }
    let(:trophy_list) { build(:trophy_list) }
    let(:ps3_platform) { build(:platform, abbreviation: 'PS3') }
    let(:ps4_platform) { build(:platform, abbreviation: 'PS4') }
    let(:psn_data) do
      {
        'trophyTitleName' => game_name,
        'trophyTitleDetail' => 'Play, Create, Share',
        'npCommunicationId' => 'NPWR00160_00',
        'npServiceName' => 'trophy',
        'trophyTitleIconUrl' => 'trophyicons.com',
        'trophyTitlePlatform' => 'PS3,PS4'
      }
    end

    before do
      allow(PSN::Services::ImportTitleTrophyList).to receive(:import).and_return(trophy_list)
      allow(Platform).to receive(:find_by!).with(ps_abbreviation: 'PS3').and_return(ps3_platform)
      allow(Platform).to receive(:find_by!).with(ps_abbreviation: 'PS4').and_return(ps4_platform)
      allow(Release).to receive(:find_or_initialize_by).and_return(release)
    end

    it 'imports the psn releases for title' do
      expect(Release).to receive(:find_or_initialize_by).with(game:, platform: ps3_platform)
      expect(Release).to receive(:find_or_initialize_by).with(game:, platform: ps4_platform)
      expect(release).to receive(:update!).with(trophy_list:).twice

      described_class.import(psn_data, game)
    end
  end
end
