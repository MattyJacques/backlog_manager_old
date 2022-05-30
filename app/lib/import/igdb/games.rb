module Import
  module IGDB
    # Handle requests to the IGDB API that are related to the games endpoint
    class Games
      ENDPOINT = 'games'

      def self.search(title)
        return if title.blank?

        params = { fields: 'name, platforms.name, genres.name' }
        params[:search] = '"' + title + '"'
        params[:limit] = 20
        Import::IGDB::Client.post(ENDPOINT, params)
      end

      def self.import(igdb_id)
        return if igdb_id.blank?

        data = get_igdb_data(igdb_id)
        import_from_data(data)
      end

      private

      def self.get_igdb_data(id)
        params = { fields: 'name, genres.name, platforms.platform_family.name,
                            platforms.name, release_dates.date, release_dates.game,
                            release_dates.platform, release_dates.region' }
        params[:where] = "id = #{id}"
        Import::IGDB::Client.post(ENDPOINT, params).first
      end

      def self.import_from_data(data)
        game = import_game(data)
        game.genres = import_genres(data.genres)
        game.platforms = import_platforms(data.platforms)
        game.release_dates = import_release_dates(game, data.release_dates)

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
          Platform.find_or_create_by!(name: platform.name, igdb_id: platform.id, platform_family: family)
        end
      end

      def self.import_release_dates(game, dates)
        dates.map do |date|
          platform = Platform.find_by!(igdb_id: date.platform)
          ReleaseDate.convert_create(game, platform, date.date)
        end
      end
    end
  end
end