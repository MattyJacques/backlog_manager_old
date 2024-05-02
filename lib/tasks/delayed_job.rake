# frozen_string_literal: true

require 'English'

namespace :delayed_job do
  desc 'Start the delayed job worker'
  task start: :environment do
    Delayed::Worker.logger = Rails.logger

    Delayed::Worker.logger.broadcast_to(
      ActiveSupport::TaggedLogging.new(
        ActiveSupport::Logger.new($stdout,
                                  formatter: Logger::Formatter.new)
      )
    )

    Rake::Task['jobs:work'].invoke
  end
end
