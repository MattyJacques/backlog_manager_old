namespace :psn do
  desc 'Import all games associated with a psn account'
  task import_trophies: :environment do
    failed_titles = []
    psn_titles = Import::PSN::Trophy.all_titles

    psn_titles.each do |title|
      game_title = title[:name].gsub(Regexp.union('®', '™', ' Trophies'), '')
      game_title = game_title.gsub(/’/, '\'').strip

      if Import::IGDB::Games.import_by_name(game_title).present?
        puts("Imported #{game_title} successfully")
      else
        puts("Failed to import #{game_title}, retrying with titleized name")

        if Import::IGDB::Games.import_by_name(game_title.titleize).present?
          puts("Imported #{game_title.titleize} successfully")
        else
          puts("Failed to import #{game_title.titleize}")
          failed_titles << game_title
        end
      end

    rescue StandardError => error
      if error.message == 'Game already exists'
        puts "Skipping #{game_title}, already exists"
      else
        raise error
      end
    end

    if (failed_titles.present?)
      puts("Failed to import #{failed_titles.count} games:")
      failed_titles.each { |title| puts(title) }
    end

    puts 'Attempt to match failures?'
    answer = gets.chomp

    if answer == 'y'
      failed_titles.each do |game_title|
        result = Import::IGDB::Games.search(game_title, 1)
        if result.present?
          puts "Is #{result[0].name} a match for #{game_title}? (y for yes, any other char for no)"
          answer = gets.chomp

          if answer == 'y'
            if Import::IGDB::Games.import_by_id(result[0].id).present?
              puts ("Imported #{game_title} successfully")
            else
              puts("Failed to import #{game_title}")
            end
          end
        end
      end
    end
  end
end
