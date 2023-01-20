# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_09_19_210634) do
  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id", null: false
    t.integer "how_long_to_beat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "games_genres", id: false, force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "genre_id", null: false
    t.index ["game_id", "genre_id"], name: "index_games_genres_on_game_id_and_genre_id"
  end

  create_table "games_platforms", id: false, force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "platform_id", null: false
    t.index ["game_id", "platform_id"], name: "index_games_platforms_on_game_id_and_platform_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_families", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id", null: false
    t.integer "platform_family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["platform_family_id"], name: "index_platforms_on_platform_family_id"
  end

  create_table "releases", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "platform_id", null: false
    t.integer "region", default: 8, null: false
    t.string "psn_communication_id"
    t.string "psn_title_id"
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "\"game\", \"platform\", \"region\", \"psn_communication_id\"", name: "unique release index", unique: true
    t.index ["game_id"], name: "index_releases_on_game_id"
    t.index ["platform_id"], name: "index_releases_on_platform_id"
  end

  create_table "trophies", force: :cascade do |t|
    t.integer "trophy_list_id", null: false
    t.integer "psn_id", null: false
    t.string "name", null: false
    t.string "detail", null: false
    t.string "icon_url", null: false
    t.integer "rank", null: false
    t.boolean "hidden", default: false, null: false
    t.integer "progress_target", default: 1
    t.string "trophy_group"
    t.string "reward_name"
    t.string "reward_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trophy_list_id", "psn_id"], name: "index_trophies_on_trophy_list_id_and_psn_id", unique: true
    t.index ["trophy_list_id"], name: "index_trophies_on_trophy_list_id"
  end

  create_table "trophy_lists", force: :cascade do |t|
    t.integer "release_id", null: false
    t.integer "region"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["release_id"], name: "index_trophy_lists_on_release_id"
  end

  add_foreign_key "platforms", "platform_families"
  add_foreign_key "releases", "games"
  add_foreign_key "releases", "platforms"
  add_foreign_key "trophies", "trophy_lists"
  add_foreign_key "trophy_lists", "releases"
end
