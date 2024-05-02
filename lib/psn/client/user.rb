# frozen_string_literal: true

module PSN
  module Client
    class User < Base
      class << self
        BASE_PATH = 'https://m.np.playstation.com/api'
        GRAPHQL_BASE_PATH = "#{BASE_PATH}/graphql/v1/op?operationName=".freeze

        # Get the profile of the user with the given PSN ID
        #
        # username [String] PSN ID
        def get_profile_from_username(username)
          raise 'PSN username must be present' if username.blank?

          get("https://us-prof.np.community.playstation.net/userProfile/v1/users/#{username}/profile2" \
              '?fields=npId,onlineId,accountId,avatarUrls,plus,aboutMe,languagesUsed,' \
              'trophySummary(@default,level,progress,earnedTrophies),isOfficiallyVerified,' \
              'personalDetail(@default,profilePictureUrls),personalDetailSharing,' \
              'personalDetailSharingRequestMessageFlag,primaryOnlineStatus,' \
              'presences(@default,@titleInfo,platform,lastOnlineDate,hasBroadcastData),requestMessageFlag,blocking,' \
              'friendRelation,following,consoleAvailability')['profile']
        end

        # Get the profile of the user with the given Account ID.
        # Prefer not to use, use from get_profile_from_username for fuller profile
        #
        # account_id [String] PSN Account ID
        def get_profile_from_account_id(account_id)
          get("#{BASE_PATH}/userProfile/v1/internal/users/#{account_id}/profiles")
        end

        # Get a list of the played game data for the given account
        # This only lists PS4 and PS5 games
        #
        # account_id [String] PSN Account ID
        def played_game_data(account_id)
          get("#{BASE_PATH}/gamelist/v2/users/#{account_id}/titles", query: { offset: 0, limit: 100 })
        end

        # Get the recently played data for the authourised PSN account
        def self_played_data
          response = get("#{GRAPHQL_BASE_PATH}getUserGameList" \
                         '&variables={"categories":"ps4_game,ps5_native_game","limit":50}' \
                         '&extensions={"persistedQuery":{"version":1,' \
                         "\"sha256Hash\":\"#{GraphqlHashes::USER_RECENTLY_PLAYED}\"}}")

          response['data']['gameLibraryTitlesRetrieve']['games']
        end

        # Get the purchase data for the authourised PSN account
        def self_purchased_data
          response = get("#{GRAPHQL_BASE_PATH}getPurchasedGameList" \
                         '&variables={"isActive":true,"platform":["ps4","ps5"],' \
                         '"size":1000,"start":0,"sortBy":"ACTIVE_DATE","sortDirection":"desc"}' \
                         '&extensions={"persistedQuery":{' \
                         "\"version\":1,\"sha256Hash\":\"#{GraphqlHashes::USER_PURCHASES}\"}}")

          response['data']['purchasedTitlesRetrieve']['games']
        end
      end
    end
  end
end
