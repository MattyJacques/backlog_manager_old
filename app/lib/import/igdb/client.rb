require 'json'
require 'net/http'
require 'ostruct'
require 'oauth2'

module Import
  module IGDB
    # Class to send generic requests to the IGDB API.
    # Request data should be setup in other classes for example import/IGDB/games.rb
    class Client
      URL = 'https://api.igdb.com/v4/'
      CLIENT_ID = ENV['IGDB_CLIENT_ID']
      CLIENT_SECRET = ENV['IGDB_CLIENT_SECRET']
      HEADER = {'Accept' => 'application/json'}

      def self.post(endpoint, params = {fields: '*'})
        uri = URI.parse(URL + endpoint)
        response = do_post_request(uri, params)
        JSON.parse(response.body, object_class: OpenStruct)
      end

      private

      def self.do_post_request(uri, params)
        data = params.map do |key, value|
          "#{key.to_s} #{value};"
        end.join('')

        with_retry_on_auth_error do
          Net::HTTP.post(
            uri,
            data,
            HEADER.merge({'Client-ID' => CLIENT_ID,
                          'Authorization' => "Bearer " + token}))
        end
      end

      def self.with_retry_on_auth_error
        response = yield

        if response.code.to_i == 401
          fetch_token

          response = yield
        end

        response
      end

      def self.token
        Rails.cache.read('igdb_token') || fetch_token
      end

      def self.fetch_token
        client = OAuth2::Client.new(ENV['IGDB_CLIENT_ID'],
                                    ENV['IGDB_CLIENT_SECRET'],
                                    site: 'https://id.twitch.tv',
                                    token_url: 'oauth2/token')
        set_token(client.client_credentials.get_token)

        Rails.cache.read('igdb_token')
      end

      def self.set_token(token)
        Rails.cache.write('igdb_token', token.token, expires_in: token.expires_in)
      end
    end
  end
end