module Import
  module PSN
    module API
      class Auth
        AUTH_URL = 'https://ca.account.sony.com/api/authz/v3/'
        BASIC_TOKEN = ENV['PSN_BASIC_TOKEN']

        def self.authenticate
          Rails.logger.info('Getting new PSN access token')

          code = fetch_auth_code
          Rails.logger.debug{"Fetched authorisation code: #{code}"}

          access_token = fetch_token(code)
          Rails.logger.debug{"Fetched access_token: #{access_token}"}

          Rails.cache.write('psn_token', access_token.token, expires_in: access_token.expires_in)

          Rails.logger.info('Acquired new PSN access token')

          access_token
        end

        private

        def self.fetch_auth_code
          response = HTTParty.get(auth_url,
                                  headers: { 'Cookie' => npsso_cookie },
                                  follow_redirects: false)
          Rails.logger.info(response)

          parse_code(response.headers['location'])
        end

        def self.fetch_token(code)
          client.auth_code.get_token( code,
                                      redirect_uri: 'com.scee.psxandroid.scecompcall://redirect',
                                      token_format: 'jwt',
                                      headers: { Authorization: "Basic #{BASIC_TOKEN}" })
        end

        def self.client
          @@client ||= OAuth2::Client.new(ENV['PSN_CLIENT_ID'], '', site: AUTH_URL)
        end

        def self.auth_url
          client.auth_code.authorize_url( access_type: 'offline',
                                          redirect_uri: 'com.scee.psxandroid.scecompcall://redirect',
                                          scope: 'psn:mobile.v2.core psn:clientapp')
        end

        private

        def self.parse_code(location)
          code = location.match(/\?code=([A-Za-z0-9:\?_\-\.\/=]+)/)

          if code.present?
            code[1]
          else
            error = location.match(/&error=([A-Za-z0-9:\?_\-\.\/=]+)/)

            message = get_error_message(error[1])
            Rails.logger.error(message)
            raise message
          end
        end

        def self.get_error_message(error)
          if error == 'login_required'
            'PSN authorisation failed, NPSSO code has expired'
          else
            "Unhandled PSN auth error (#{error})"
          end
        end

        def self.npsso_cookie
          "npsso=#{ENV['PSN_NPSSO']}"
        end
      end
    end
  end
end