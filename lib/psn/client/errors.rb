# frozen_string_literal: true

module PSN
  module Client
    module Errors
      class PSNError < StandardError; end

      class HiddenDataError < PSNError
        def initialize
          super('User has hidden their data')
        end
      end
    end
  end
end
