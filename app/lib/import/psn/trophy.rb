module Import
  module PSN
    class Trophy
      def self.title_trophy_list(communication_id, service_name)
        Rails.logger.info("Retrieving trophy list for title #{communication_id}")

        Import::PSN::API::Trophy.title_trophy_list(communication_id, service_name)['trophies']
      end

      def self.earned_trophies_for_title(communication_id, service_name, account_id = 'me')
        Rails.logger.debug{"Retrieving earned trophies for title #{communication_id} for #{account_id}"}

        Import::PSN::API::Trophy.title_trophy_list(communication_id, service_name, account_id)['trophies']
      end

      # Get all titles that have been synced with the account
      def self.all_titles
        titles = parse_titles_response
        titles += parse_titles_response(800) if titles.count == 800

        Rails.logger.debug{"Retrieved #{titles.count} PSN titles for me"}

        titles
      end

      # Get a list of all trophies that the account has earned
      def self.all_trophies
        titles = titles_with_earned
        trophies = titles.map do |title|
          title_trophies = earned_trophies_for_title(title[:communication_id], title[:service_name])
          title_trophies.filter{ |trophy| trophy['earnedDateTime'].present? }
        end

        Rails.logger.info("Retrieved #{trophies.count} trophies for me")

        trophies.flatten
      end

      def self.trophy_streak
        trophies = all_trophies

        timestamps = trophies.map do |trophy|
          DateTime.parse(trophy['earnedDateTime'])
        end

        dates = (timestamps.map &:to_date).uniq!.sort!.reverse!
        no_trophy_dates = Array.new
        '2017/01/01'.to_date.upto(Date.today) do |date|
          no_trophy_dates << date unless dates.include?(date)
        end

        no_trophy_dates
      end

      private

      # Get all the titles synced to the account with at least one earned trophy
      def self.titles_with_earned
        all_titles.filter { |title| title[:progress] > 0 }
      end

      def self.parse_titles_response(offset = 0)
        title_response = Import::PSN::API::Trophy.account_titles(offset: offset)

        title_response['trophyTitles'].map do |title|
          {
            name: title['trophyTitleName'],
            platform: title['trophyTitlePlatform'],
            progress: title['progress'],
            communication_id: title['npCommunicationId'],
            service_name: title['npServiceName']
          }
        end
      end
    end
  end
end