module Import
  module IGDB
    # Handle requests to the IGDB API that are related to the games endpoint
    class Games
      ENDPOINT = 'games'

      def self.search(title, platform_id: nil, limit: 20)
        return if title.blank?

        params = { fields: 'name, platforms.name, genres.name' }
        params[:search] = "\"#{title}\""
        params[:where] = "platforms = (#{platform_id})" if platform_id.present?
        params[:limit] = limit
        Import::IGDB::Client.post(ENDPOINT, params)
      end

      def self.import_by_id(igdb_id)
        return if igdb_id.blank?

        params = import_param_fields
        params[:where] = "id = #{igdb_id}"

        import(params)
      end

      def self.import_by_name(name)
        return if name.blank?

        params = import_param_fields
        params[:where] = "name = \"#{name}\""

        import(params)
      end

      private

      def self.import(params)
        data = get_igdb_data(params)
        import_from_data(data) if data.present?
      end

      def self.get_igdb_data(params)
        Import::IGDB::Client.post(ENDPOINT, params).first
      end

      def self.import_from_data(data)
        raise 'Game already exists' if Game.where(igdb_id: data.id).count > 0

        game = import_game(data)
        game.genres = import_genres(data.genres) if data.genres.present?
        game.platforms = import_platforms(data.platforms) if data.platforms.present?
        game.releases = import_releases(game, data.release_dates) if data.release_dates.present?

        game
      end

      def self.import_game(data)
        Game.create!(name: data.name, igdb_id: data.id)
      end

      def self.import_genres(genres)
        genres.map { |genre| Genre.find_or_create_by!(igdb_id: genre.id, name: genre.name) }
      end

      def self.import_platforms(platforms)
        platforms.map do |platform|
          family_data = platform.platform_family
          family = PlatformFamily.find_or_create(family_data&.id, family_data&.name)
          Platform.find_or_create_by!(name: platform.name,
                                      abbreviation: platform.abbreviation,
                                      igdb_id: platform.id,
                                      platform_family: family)
        end
      end

      def self.import_releases(game, dates)
        dates&.map do |date|
          platform = Platform.find_by!(igdb_id: date.platform)
          Release.convert_timestamp_and_create(game, platform, date.region, date.date)
        end
      end

      def self.import_param_fields
        { fields: 'name, genres.name, platforms.platform_family.name,
          platforms.name, platforms.abbreviation, release_dates.date, release_dates.game,
          release_dates.platform, release_dates.region' }
      end
    end
  end
end
