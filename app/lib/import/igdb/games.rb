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
    end
  end
end