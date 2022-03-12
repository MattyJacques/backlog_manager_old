Genre.create!([
  {name: "Adventure"},
  {name: "Shooter"}
])
PlatformFamily.create!([
  {name: "PlayStation"}
])
Platform.create!([
  {name: "PlayStation 5", release_date: nil, platform_family_id: 1}
])
Game.create!([
  {name: "The Last of Us", genres: [Genre.find_by_id(1), Genre.find_by_id(2)], platforms: [Platform.find_by_id(1)]}
])
