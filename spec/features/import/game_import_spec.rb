require 'rails_helper'

RSpec.feature 'GameImports', type: :feature do
  scenario 'User imports new game from IGDB' do
    visit(games_path)
    click_button('Import game')
    fill_in('search', with: 'The Last of Us')
    click_button('Search')

    expect(page).to have_content("Import\nThe Last of Us PlayStation 3 Shooter, Adventure")

    find('button[id="The Last of Us"]').click

    game = Game.last
    expect(page).to have_content("\nShow Game\n")
    expect(game.name).to eq('The Last of Us')
    expect(game.igdb_id).to eq(1009)
    expect(game.genres[0].name).to eq('Shooter')
    expect(game.genres[1].name).to eq('Adventure')
    expect(game.platforms[0].name).to eq('PlayStation 3')
    expect(game.platforms[0].platform_family.name).to eq('PlayStation')
    expect(game.releases[0].date).to eq(Date.new(2013, 6, 14))
    expect(game.releases[1].date).to eq(Date.new(2013, 6, 14))
  end
end
