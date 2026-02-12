# rubocop:disable RSpec/ExampleLength
# rubocop:disable RSpec/MultipleExpectations
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSN::Client::User do
  describe '.get_profile_from_username' do
    let(:expected_profile_keys) do
      %w[onlineId accountId npId avatarUrls plus aboutMe languagesUsed trophySummary isOfficiallyVerified
         personalDetailSharing personalDetailSharingRequestMessageFlag friendRelation requestMessageFlag blocking
         following]
    end
    let(:profile_response) do
      {
        'onlineId' => 'Hakoom',
        'accountId' => '6796840136244039860',
        'npId' => 'SGFrb29tQGEyLnVz',
        'avatarUrls' => [{ 'size' => 'l', 'avatarUrl' => 'http://example.com/avatar.png' }],
        'plus' => 1,
        'aboutMe' => '',
        'languagesUsed' => %w[en en-GB],
        'trophySummary' => {
          'level' => 999,
          'progress' => 0,
          'earnedTrophies' => { 'platinum' => 7293, 'gold' => 54_827, 'silver' => 49_414, 'bronze' => 94_864 }
        },
        'isOfficiallyVerified' => false,
        'personalDetailSharing' => 'no',
        'personalDetailSharingRequestMessageFlag' => false,
        'friendRelation' => 'no',
        'requestMessageFlag' => false,
        'blocking' => false,
        'following' => false
      }
    end

    before do
      stub_psn_get_profile_from_username('Hakoom', profile_response)
    end

    it 'returns profile with the given username' do
      response = described_class.get_profile_from_username('Hakoom')

      expect(response.values_at(*expected_profile_keys)).not_to include(nil)
    end
  end

  describe '.get_profile_from_account_id' do
    let(:expected_keys) do
      %w[onlineId aboutMe avatars languages isPlus isOfficiallyVerified isMe]
    end
    let(:expected_avatars_keys) do
      %w[size url]
    end
    let(:profile_response) do
      {
        'onlineId' => 'Hakoom',
        'aboutMe' => 'Test bio',
        'avatars' => [{ 'size' => 'l', 'url' => 'http://example.com/avatar.png' }],
        'languages' => %w[en en-GB],
        'isPlus' => true,
        'isOfficiallyVerified' => false,
        'isMe' => false
      }
    end

    before do
      stub_psn_get_profile_from_account_id('6796840136244039860', profile_response)
    end

    it 'returns profile for given account ID' do
      response = described_class.get_profile_from_account_id('6796840136244039860')

      expect(response.values_at(*expected_keys)).not_to include(nil)
      expect(response['avatars'].first.values_at(*expected_avatars_keys)).not_to include(nil)
    end
  end

  describe '.played_game_data' do
    let(:expected_keys) do
      %w[titleId name localizedName imageUrl localizedImageUrl category service playCount concept media
         firstPlayedDateTime lastPlayedDateTime playDuration]
    end
    let(:games_response) do
      {
        'titles' => [
          {
            'titleId' => 'CUSA00001_00',
            'name' => 'Test Game',
            'localizedName' => 'Test Game',
            'imageUrl' => 'http://example.com/image.png',
            'localizedImageUrl' => 'http://example.com/image.png',
            'category' => 'ps4_game',
            'service' => 'none',
            'playCount' => 10,
            'concept' => { 'id' => 123 },
            'media' => { 'type' => 'disc' },
            'firstPlayedDateTime' => '2023-01-01T00:00:00Z',
            'lastPlayedDateTime' => '2023-06-01T00:00:00Z',
            'playDuration' => 'PT100H'
          }
        ]
      }
    end

    before do
      stub_psn_played_game_data('5340552997727798155', games_response)
    end

    it 'returns the played game data for the given account' do
      response = described_class.played_game_data('5340552997727798155')

      expect(response['titles'].last.values_at(*expected_keys)).not_to include(nil)
    end
  end

  describe '.self_played_data' do
    let(:played_data_response) do
      {
        'data' => {
          'gameLibraryTitlesRetrieve' => {
            'games' => [
              {
                '__typename' => 'GameLibraryTitle',
                'conceptId' => '12345',
                'entitlementId' => 'EP0001-CUSA00001_00',
                'image' => { 'url' => 'http://example.com/image.png' },
                'isActive' => true,
                'lastPlayedDateTime' => '2023-06-01T00:00:00Z',
                'membership' => nil,
                'name' => 'Test Game',
                'platform' => 'PS5',
                'productId' => 'EP0001-CUSA00001_00',
                'titleId' => 'CUSA00001_00'
              }
            ]
          }
        }
      }
    end

    before do
      stub_psn_self_played_data(played_data_response)
    end

    it 'returns the played data for the authorised account' do
      response = described_class.self_played_data.first

      expect(response.key?('__typename')).to be(true)
      expect(response.key?('conceptId')).to be(true)
      expect(response.key?('entitlementId')).to be(true)
      expect(response.key?('image')).to be(true)
      expect(response.key?('isActive')).to be(true)
      expect(response.key?('lastPlayedDateTime')).to be(true)
      expect(response.key?('membership')).to be(true)
      expect(response.key?('name')).to be(true)
      expect(response.key?('platform')).to be(true)
      expect(response.key?('productId')).to be(true)
      expect(response.key?('titleId')).to be(true)
    end
  end

  describe '.self_purchased_data' do
    let(:purchased_data_response) do
      {
        'data' => {
          'purchasedTitlesRetrieve' => {
            'games' => [
              {
                '__typename' => 'PurchasedTitle',
                'conceptId' => '12345',
                'entitlementId' => 'EP0001-CUSA00001_00',
                'image' => { 'url' => 'http://example.com/image.png' },
                'isActive' => true,
                'isDownloadable' => true,
                'isPreOrder' => false,
                'membership' => nil,
                'name' => 'Test Game',
                'platform' => 'PS5',
                'productId' => 'EP0001-CUSA00001_00',
                'titleId' => 'CUSA00001_00'
              }
            ]
          }
        }
      }
    end

    before do
      stub_psn_self_purchased_data(purchased_data_response)
    end

    it 'returns the played data for the authorised account' do
      response = described_class.self_purchased_data.first

      expect(response.key?('__typename')).to be(true)
      expect(response.key?('conceptId')).to be(true)
      expect(response.key?('entitlementId')).to be(true)
      expect(response.key?('image')).to be(true)
      expect(response.key?('isActive')).to be(true)
      expect(response.key?('isDownloadable')).to be(true)
      expect(response.key?('isPreOrder')).to be(true)
      expect(response.key?('membership')).to be(true)
      expect(response.key?('name')).to be(true)
      expect(response.key?('platform')).to be(true)
      expect(response.key?('productId')).to be(true)
      expect(response.key?('titleId')).to be(true)
    end
  end
end

# rubocop:enable RSpec/ExampleLength
# rubocop:enable RSpec/MultipleExpectations
