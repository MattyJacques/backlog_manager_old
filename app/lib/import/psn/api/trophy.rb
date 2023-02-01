module Import
  module PSN
    module API
      class Trophy
        NP_SERVICE_NAMES = ['trophy', 'trophy2']
        TITLES_LIMIT = 800

        # Get the trophy summary for the given account
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=trophy-profile-summary
        #
        # accountId [String] PSN account ID, use 'me' for authenticating account
        def self.account_summary(account_id = 'me')
          raise 'account_id must be present' unless account_id.present?

          Import::PSN::API::Client.get("/trophy/v1/users/#{account_id}/trophySummary")
        end

        # Get synced trophy titles for the given account, can provided title IDs to get summaries of specified titles
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_2-retrieve-the-trophies-for-a-title
        #
        # offset [Integer] { min: 0, max: totalItemCount - 1 }
        # limit [Integer] { min: 1, max: 800 }
        def self.account_titles(offset: 0, limit: 800)
          raise 'limit must be less than or equal to 800' if limit > TITLES_LIMIT

          Import::PSN::API::Client.get('/trophy/v1/users/me/trophyTitles',
                                        query: {
                                          offset: offset,
                                          limit: limit
                                        })
        end

        # Get the trophy list for the title with the given communication ID, can get trophy list for specific
        # trophy group.
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_2-retrieve-the-trophies-for-a-title
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_3-retrieve-trophies-earned-for-a-title
        #
        # communication_id [String] Communication ID of title
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        # trophy_group_id [String] { 'all' || 'default' || '001' || '002' }
        def self.title_trophy_list(communication_id, service_name = 'trophy', account_id = nil, trophy_group_id = 'all')
          raise 'communication_id must be present' unless communication_id.present?
          raise 'service must be \'trophy\' or \'trophy2\'' unless ['trophy', 'trophy2'].include?(service_name)
          raise 'group id must be \'all\' or \'default\' or \'001\' or \'002\'' unless ['all', 'default', '001', '002'].include?(trophy_group_id)

          Import::PSN::API::Client.get(
            "/trophy/v1/#{account_path(account_id)}npCommunicationIds/#{communication_id}/trophyGroups#{trophy_group_path(trophy_group_id)}",
            query: {
              npServiceName: service_name
            })
        end

        # Get a trophy summary for the given titles
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=trophy-title-summary-for-specific-title-id
        #
        # title_ids [Array[String]] ['CUSA09171', 'PPSA01284_00', 'PPSA04874_00']
        def self.account_summary_for_title(account_id, title_ids)
          raise 'account_id must be present' unless account_id.present?
          raise 'title_ids size must be less than or equal to 5' unless title_ids.length.between?(1, 5)

          Import::PSN::API::Client.get("/trophy/v1/users/#{account_id}/titles/trophyTitles",
            query: {
              npTitleIds: title_ids.join(','),
            })
        end

        # Get the data for a specific trophy, can be earned status or general
        #
        # communication_id [String] Communication ID of the title
        # trophy_id [Integer] ID of the trophy within the title trophy list
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        def self.trophy(communication_id, trophy_id, service_name = 'trophy', account_id = nil)
          raise 'service_name should be \'trophy\' or \'trophy2\'' unless NP_SERVICE_NAMES.include?(service_name)

          Import::PSN::API::Client.get(
            "/trophy/v1/#{account_path(account_id)}npCommunicationIds/#{communication_id}/trophies/#{trophy_id}",
            query: {
              npServiceName: service_name
            })
        end

        # Get data on the trophy groups (main list and DLCs etc) for a title.
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=title-trophy-groups
        #
        # communication_id [String] Communication ID of the title
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        def self.trophy_groups(communication_id, service_name = 'trophy', account_id = nil)
          raise 'service_name should be \'trophy\' or \'trophy2\'' unless NP_SERVICE_NAMES.include?(service_name)

          Import::PSN::API::Client.get(
            "/trophy/v1/#{account_path(account_id)}npCommunicationIds/#{communication_id}/trophyGroups",
            query: {
              npServiceName: service_name
            })
        end

        private

        def self.trophy_group_path(group_id)
          "/#{group_id}/trophies" if group_id
        end

        def self.account_path(account_id)
          "users/#{account_id}/" if account_id
        end
      end
    end
  end
end