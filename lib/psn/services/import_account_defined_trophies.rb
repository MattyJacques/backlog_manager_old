# frozen_string_literal: true

module PSN
  module Services
    class ImportAccountDefinedTrophies
      class << self
        def import(account_id)
          Rails.logger.info("Importing defined trophies on #{account_id}")

          titles = PSN::Client::Trophy.all_account_titles(account_id)

          Rails.logger.info("Retrieved #{titles.count} titles")

          titles&.map do |title|
            import_title(title)
            TrophyList.find_by!(comm_id: title['npCommunicationId'])
          end
        end

        private

        def import_title(title)
          return if list_exists?(title['npCommunicationId'])

          ActiveRecord::Base.transaction do
            game = IGDB::Services::ImportGame.import(title['trophyTitleName'], platform(title['trophyTitlePlatform']))
            PSN::Services::ImportPSNRelease.import(title, game)
          rescue RuntimeError
            PSN::Services::ImportPSNRelease.import(title, Game.new(name: title['trophyTitleName']))
          end
        end

        def list_exists?(comm_id)
          TrophyList.exists?(comm_id:)
        end

        def platform(platforms_string)
          Platform.where(abbreviation: platforms_string.split(','))
        end
      end
    end
  end
end
