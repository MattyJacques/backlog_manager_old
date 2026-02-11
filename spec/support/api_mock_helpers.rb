# frozen_string_literal: true

require 'webmock/rspec'

# Helper module for stubbing PSN and IGDB API calls
module APIMockHelpers
  # PSN API Mock Helpers
  module PSN
    AUTH_URL = 'https://ca.account.sony.com/api/authz/v3/oauth/authorize'
    TOKEN_URL = 'https://ca.account.sony.com/api/authz/v3/oauth/token'

    def stub_psn_auth_success
      # Stub the auth code request
      stub_request(:get, /ca\.account\.sony\.com\/api\/authz\/v3\/oauth\/authorize/)
        .to_return(
          status: 302,
          headers: {
            'Location' => 'com.scee.psxandroid.scecompcall://redirect/?code=v1.Ab23CD&cid=test-cid'
          }
        )

      # Stub the token request
      stub_request(:post, TOKEN_URL)
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            access_token: 'test_access_token',
            token_type: 'bearer',
            expires_in: 3599,
            scope: 'psn:mobile.v2.core psn:clientapp',
            id_token: 'test_id_token',
            refresh_token: 'test_refresh_token',
            refresh_token_expires_in: 5_183_999
          }.to_json
        )
    end

    def stub_psn_auth_npsso_expired
      stub_request(:get, /ca\.account\.sony\.com\/api\/authz\/v3\/oauth\/authorize/)
        .to_return(
          status: 302,
          headers: {
            'Location' => 'https://my.account.sony.com/central/signin/?response_type=code&error=login_required&error_code=4165'
          }
        )
    end

    def stub_psn_get_profile_from_username(username, response_body)
      stub_psn_auth_success
      stub_request(:get, /us-prof\.np\.community\.playstation\.net\/userProfile\/v1\/users\/#{username}\/profile2/)
        .to_return(status: 200, body: { 'profile' => response_body }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_get_profile_from_account_id(account_id, response_body)
      stub_psn_auth_success
      stub_request(:get, /m\.np\.playstation\.com\/api\/userProfile\/v1\/internal\/users\/#{account_id}\/profiles/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_account_summary(account_id, response_body)
      stub_psn_auth_success
      stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/trophySummary/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_account_titles(account_id, response_body)
      stub_psn_auth_success
      stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/trophyTitles/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_title_trophy_list(np_comm_id, response_body, account_id: nil)
      stub_psn_auth_success
      if account_id
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/npCommunicationIds\/#{np_comm_id}\/trophyGroups\/all\/trophies/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      else
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/npCommunicationIds\/#{np_comm_id}\/trophyGroups\/all\/trophies/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end
    end

    def stub_psn_trophy(np_comm_id, trophy_id, response_body, account_id: nil)
      stub_psn_auth_success
      if account_id
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/npCommunicationIds\/#{np_comm_id}\/trophies\/#{trophy_id}/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      else
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/npCommunicationIds\/#{np_comm_id}\/trophies\/#{trophy_id}/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end
    end

    def stub_psn_trophy_groups(np_comm_id, response_body, account_id: nil)
      stub_psn_auth_success
      if account_id
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/npCommunicationIds\/#{np_comm_id}\/trophyGroups/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      else
        stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/npCommunicationIds\/#{np_comm_id}\/trophyGroups/)
          .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
      end
    end

    def stub_psn_account_summary_for_title(account_id, response_body)
      stub_psn_auth_success
      stub_request(:get, /ps5\.np\.playstation\.net\/api\/trophy\/v1\/users\/#{account_id}\/titles\/trophyTitles/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_played_game_data(account_id, response_body)
      stub_psn_auth_success
      stub_request(:get, /m\.np\.playstation\.com\/api\/gamelist\/v2\/users\/#{account_id}\/titles/)
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_self_played_data(response_body)
      stub_psn_auth_success
      stub_request(:get, /m\.np\.playstation\.com\/api\/graphql\/v1\/op/)
        .with(query: hash_including('operationName' => 'getUserGameList'))
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_self_purchased_data(response_body)
      stub_psn_auth_success
      stub_request(:get, /m\.np\.playstation\.com\/api\/graphql\/v1\/op/)
        .with(query: hash_including('operationName' => 'getPurchasedGameList'))
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_psn_401_then_success(url_pattern, response_body)
      stub_psn_auth_success
      stub_request(:get, url_pattern)
        .to_return(
          { status: 401, body: { error: { message: 'Unauthorized' } }.to_json },
          { status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' } }
        )
    end
  end

  # IGDB API Mock Helpers
  module IGDB
    AUTH_URL = 'https://id.twitch.tv/oauth2/token'

    def stub_igdb_auth_success
      stub_request(:post, AUTH_URL)
        .to_return(
          status: 200,
          headers: { 'Content-Type' => 'application/json' },
          body: {
            access_token: 'test_igdb_token',
            expires_in: 4_698_019,
            token_type: 'bearer'
          }.to_json
        )
    end

    def stub_igdb_post(endpoint, response_body)
      stub_igdb_auth_success
      stub_request(:post, "https://api.igdb.com/v4/#{endpoint}")
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def stub_igdb_401_then_success(endpoint, response_body)
      stub_igdb_auth_success
      stub_request(:post, "https://api.igdb.com/v4/#{endpoint}")
        .to_return(
          { status: 401, body: { message: 'Unauthorized' }.to_json },
          { status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' } }
        )
    end
  end

  # PSNP+ API Mock Helpers
  module PSNP
    def stub_psnp_unobtainable_list(response_body)
      stub_request(:get, 'https://psnp-plus.huskycode.dev/list.min.json')
        .to_return(status: 200, body: response_body.to_json, headers: { 'Content-Type' => 'application/json' })
    end
  end
end

RSpec.configure do |config|
  config.include APIMockHelpers::PSN
  config.include APIMockHelpers::IGDB
  config.include APIMockHelpers::PSNP
end
