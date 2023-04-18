module ImportHelper
  def get_psn_titles
    psn_games = Import::PSN::Trophy.all_titles
    games = []

    psn_games.each do |psn_game|
      games.append(
        {
          psn_name: psn_game[:name],
          psn_platform: psn_game[:platform]
        }
      )
    end

    games
  end

  def get_psn_igdb_tiles
    psn_games = Import::PSN::Trophy.all_titles
    games = []

    psn_games.each do |psn_game|
      name = psn_game[:name].gsub(Regexp.union('®', '™', ' Trophies'), '').gsub(/’/, '\'').strip
      platform_id = Platform.find_by(abbreviation: psn_game[:platform].split(',')[0])&.igdb_id
      igdb_result = Import::IGDB::Games.search(name, platform_id: platform_id, limit: 1)

      games.append(
        {
          psn_name: psn_game[:name],
          psn_platform: psn_game[:platform],
          igdb_name: igdb_result[0]&.name,
          igdb_platform: igdb_result[0]&.platforms&.map{ |platform| platform.name }&.join(', '),
          igdb_id: igdb_result[0]&.id
        }
      )
    end

    games
  end
end
