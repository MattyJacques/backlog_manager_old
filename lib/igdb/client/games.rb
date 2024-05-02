# frozen_string_literal: true

module IGDB
  module Client
    class Games < Base
      ENDPOINT = 'games'

      class << self
        # Search IGDB for a game with the given name
        def search(name, platforms = nil, full_data: false, limit: 20)
          raise 'Search query should not be blank' if name.blank?

          Rails.logger.info("Searching IGDB for #{name}")

          params = full_data ? import_param_fields : search_param_fields
          params[:search] = "\"#{name}\""
          params[:where] = "category = (0,8,9,10,11) & version_parent = null #{platform_string(platforms)}"
          params[:limit] = limit

          post(ENDPOINT, params)
        end

        def get_by_name(name)
          raise 'Game name should not be blank' if name.blank?

          params = import_param_fields
          params[:where] = "name = \"#{name}\""

          post(ENDPOINT, params).first
        end

        def get_by_id(igdb_id)
          raise 'IGDB ID should not be blank' if igdb_id.blank?

          params = import_param_fields
          params[:where] = "id = #{igdb_id}"

          post(ENDPOINT, params).first
        end

        private

        def platform_string(platforms)
          if platforms.present?
            "& platforms = (#{platforms.map(&:igdb_id)})"
          else
            ''
          end
        end

        def search_param_fields
          {
            fields: 'name, platforms.name, genres.name, category, parent_game'
          }
        end

        def import_param_fields
          {
            fields: 'name, genres.name, platforms.platform_family.name,
                     platforms.name, release_dates.date, release_dates.game,
                     release_dates.platform, release_dates.region'
          }
        end
      end
    end
  end
end
