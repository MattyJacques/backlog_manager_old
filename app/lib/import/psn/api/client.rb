require 'httparty'

module Import
  module PSN
    module API
      class Client
        BASE_PATH = 'https://ps5.np.playstation.net/api'

        def self.get(path, options = {})
          Rails.logger.info("Sending request to PSN: #{path}, options: #{options}")

          do_get_request(BASE_PATH + path, options)
        end

        private

        def self.do_get_request(path, options = {})
          with_retry_on_auth_error do
            res = HTTParty.get(path, headers: { 'Authorization' => "Bearer #{ token }" }, **options, :verify => false)
          end
        end

        def self.with_retry_on_auth_error
          response = yield

          if response.code.to_i == 401
            Import::PSN::API::Auth.authenticate

            response = yield
          end

          Rails.logger.debug("PSN response: #{response.to_s.encode('utf-8',
                                                                  :invalid => :replace,
                                                                  :undef => :replace,
                                                                  :replace => '_')}")
          response
        end

        def self.token
          Rails.cache.read('psn_token') || Import::PSN::API::Auth.authenticate.token
        end
      end
    end
  end
end