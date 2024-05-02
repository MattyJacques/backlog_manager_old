# frozen_string_literal: true

module IGDB
  module Client
    class Base
      URL = 'https://api.igdb.com/v4/'
      CLIENT_ID = ENV.fetch('IGDB_CLIENT_ID', nil)

      class << self
        def post(endpoint, params = { fields: '*' })
          uri = URI.parse(URL + endpoint)
          do_post_request(uri, params)
        end

        private

        def do_post_request(uri, params)
          data = params.map do |key, value|
            "#{key} #{value};"
          end.join

          Rails.logger.debug { "IGDB request data: #{data}" }

          with_retry_on_auth_error do
            HTTParty.post(uri,
                          headers: { 'Client-ID' => ENV.fetch('IGDB_CLIENT_ID', nil),
                                     'Authorization' => "Bearer #{token}" },
                          body: data)
          end
        end

        def with_retry_on_auth_error
          response = yield

          if response.code.to_i == 401
            # Clear the expired token
            Rails.cache.delete('igdb_token')

            response = yield
          end

          Rails.logger.debug do
            "IGDB response: #{response}"
          end

          response
        end

        def token
          # IGDB token seems to last just over 64 days
          Rails.cache.fetch('igdb_token', expires_in: 64.days) do
            IGDB::Client::Auth.authenticate
          end
        end
      end
    end
  end
end
