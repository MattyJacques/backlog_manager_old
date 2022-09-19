PlatformFamily.create!([
  { name: "PlayStation", igdb_id: 1 },
  { name: "Xbox", igdb_id: 2 },
  { name: "Nintendo", igdb_id: 5 }
])
Platform.create!([
  { name: "PC (Microsoft Windows)", igdb_id: 6 },
  { name: "PlayStation 4", igdb_id: 48, platform_family_id: 1 },
  { name: "Xbox One", igdb_id: 49, platform_family_id: 2 },
  { name: "PlayStation 5", igdb_id: 167, platform_family_id: 1 },
  { name: "Xbox Series X|S", igdb_id: 169, platform_family_id: 2 },
  { name: "Google Stadia", igdb_id: 170 },
  { name: "Nintendo Switch", igdb_id: 130, platform_family_id: 3 },
  { name: "PlayStation 3", igdb_id: 9, platform_family_id: 1 }
])
Genre.create!([
  { name: "Adventure", igdb_id: 31 },
  { name: "Shooter", igdb_id: 5 },
  { name: "Tactical", igdb_id: 24 },
  { name: "Role-playing (RPG)", igdb_id: 12 }
])
Game.create!([
  { name: "Marvel's Avengers", igdb_id: 26950, genres: [Genre.find_by_id(1)], platforms: [Platform.find_by_id(1), Platform.find_by_id(2), Platform.find_by_id(3), Platform.find_by_id(4), Platform.find_by_id(5), Platform.find_by_id(6)] },
  { name: "Luigi's Mansion 3", igdb_id: 109455, genres: [Genre.find_by_id(1)], platforms: [Platform.find_by_id(7)] },
  { name: "The Last of Us", igdb_id: 1009, genres: [Genre.find_by_id(2), Genre.find_by_id(1)], platforms: [Platform.find_by_id(8)] },
  { name: "The Last of Us Part II", igdb_id: 26192, genres: [Genre.find_by_id(2), Genre.find_by_id(1)], platforms: [Platform.find_by_id(2)] },
  { name: "Tom Clancy's The Division 2", igdb_id: 90099, genres: [Genre.find_by_id(2), Genre.find_by_id(3)], platforms: [Platform.find_by_id(1), Platform.find_by_id(2), Platform.find_by_id(3), Platform.find_by_id(6)] },
  { name: "Tom Clancy's Rainbow Six Siege", igdb_id: 7360, genres: [Genre.find_by_id(2), Genre.find_by_id(3)], platforms: [Platform.find_by_id(1), Platform.find_by_id(2), Platform.find_by_id(3), Platform.find_by_id(4), Platform.find_by_id(5), Platform.find_by_id(6)] },
  { name: "Destiny 2", igdb_id: 25657, genres: [Genre.find_by_id(2), Genre.find_by_id(4), Genre.find_by_id(3), Genre.find_by_id(1)], platforms: [Platform.find_by_id(1), Platform.find_by_id(2), Platform.find_by_id(3), Platform.find_by_id(4), Platform.find_by_id(5), Platform.find_by_id(6)] }
])
Release.create!([
  { date: Date.new(2020, 9, 4), game_id: 1, platform_id: 2, region: 8 },
  { date: Date.new(2020, 9, 4), game_id: 1, platform_id: 3, region: 8 },
  { date: Date.new(2020, 9, 4), game_id: 1, platform_id: 1, region: 8 },
  { date: Date.new(2021, 3, 18), game_id: 1, platform_id: 4, region: 8 },
  { date: Date.new(2021, 3, 18), game_id: 1, platform_id: 5, region: 8 },
  { date: Date.new(2020, 9, 4), game_id: 1, platform_id: 6, region: 8 },
  { date: Date.new(2020, 9, 4), game_id: 1, platform_id: 5, region: 2 },
  { date: Date.new(2019, 10, 31), game_id: 2, platform_id: 7, region: 8 },
  { date: Date.new(2013, 6, 14), game_id: 3, platform_id: 8, region: 2 },
  { date: Date.new(2013, 6, 14), game_id: 3, platform_id: 8, region: 1 },
  { date: Date.new(2020, 6, 19), game_id: 4, platform_id: 2, region: 8 },
  { date: Date.new(2019, 3, 15), game_id: 5, platform_id: 3, region: 8 },
  { date: Date.new(2019, 3, 15), game_id: 5, platform_id: 2, region: 8 },
  { date: Date.new(2019, 3, 15), game_id: 5, platform_id: 1, region: 8 },
  { date: Date.new(2020, 3, 17), game_id: 5, platform_id: 6, region: 8 },
  { date: Date.new(2020, 12, 1), game_id: 6, platform_id: 4, region: 8 },
  { date: Date.new(2020, 12, 1), game_id: 6, platform_id: 5, region: 8 },
  { date: Date.new(2015, 12, 1), game_id: 6, platform_id: 3, region: 8 },
  { date: Date.new(2015, 12, 1), game_id: 6, platform_id: 2, region: 8 },
  { date: Date.new(2021, 6, 30), game_id: 6, platform_id: 6, region: 8 },
  { date: Date.new(2015, 12, 1), game_id: 6, platform_id: 1, region: 2 },
  { date: Date.new(2017, 9, 6), game_id: 7, platform_id: 2, region: 8 },
  { date: Date.new(2017, 9, 6), game_id: 7, platform_id: 3, region: 8 },
  { date: Date.new(2017, 9, 6), game_id: 7, platform_id: 2, region: 2 },
  { date: Date.new(2017, 9, 6), game_id: 7, platform_id: 2, region: 1 },
  { date: Date.new(2017, 9, 6), game_id: 7, platform_id: 3, region: 2 },
  { date: Date.new(2017, 10, 24), game_id: 7, platform_id: 1, region: 8 },
  { date: Date.new(2020, 12, 8), game_id: 7, platform_id: 4, region: 8 },
  { date: Date.new(2020, 12, 8), game_id: 7, platform_id: 5, region: 8 },
  { date: Date.new(2019, 11, 19), game_id: 7, platform_id: 6, region: 8 },
])
