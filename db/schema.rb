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

ActiveRecord::Schema[7.1].define(version: 2024_01_06_095817) do
  create_table "account_trophy_lists", force: :cascade do |t|
    t.integer "psn_account_id", null: false
    t.integer "trophy_list_id", null: false
    t.integer "earned_bronze", default: 0, null: false
    t.integer "earned_silver", default: 0, null: false
    t.integer "earned_gold", default: 0, null: false
    t.integer "earned_platinum", default: 0, null: false
    t.datetime "psn_updated_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_account_id", "trophy_list_id"], name: "unique account trophy lists", unique: true
    t.index ["psn_account_id"], name: "index_account_trophy_lists_on_psn_account_id"
    t.index ["trophy_list_id"], name: "index_account_trophy_lists_on_trophy_list_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "earned_trophies", force: :cascade do |t|
    t.integer "account_trophy_list_id", null: false
    t.integer "trophy_id", null: false
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_trophy_list_id", "trophy_id"], name: "unique account trophies", unique: true
    t.index ["account_trophy_list_id"], name: "index_earned_trophies_on_account_trophy_list_id"
    t.index ["trophy_id"], name: "index_earned_trophies_on_trophy_id"
  end

  create_table "game_statuses", force: :cascade do |t|
    t.integer "status", null: false
    t.integer "user_id", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_statuses_on_game_id"
    t.index ["user_id"], name: "index_game_statuses_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id"
    t.integer "how_long_to_beat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["how_long_to_beat_id"], name: "unique game HLTB ID index", unique: true
    t.index ["igdb_id"], name: "unique game IGDB ID index", unique: true
  end

  create_table "games_genres", id: false, force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "genre_id", null: false
    t.index ["game_id", "genre_id"], name: "index_games_genres_on_game_id_and_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "platform_families", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique family IGDB ID index", unique: true
    t.index ["name"], name: "unique family name index", unique: true
    t.index ["slug"], name: "unique family slug index", unique: true
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "ps_abbreviation"
    t.integer "igdb_id"
    t.string "slug"
    t.integer "platform_family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique platform IGDB ID index", unique: true
    t.index ["name"], name: "unique platform name index", unique: true
    t.index ["platform_family_id"], name: "index_platforms_on_platform_family_id"
    t.index ["slug"], name: "unique platform slug index", unique: true
  end

  create_table "psn_accounts", force: :cascade do |t|
    t.integer "user_id"
    t.string "psn_id"
    t.string "account_id"
    t.string "avatar"
    t.boolean "plus", default: false, null: false
    t.integer "earned_bronze", default: 0, null: false
    t.integer "earned_silver", default: 0, null: false
    t.integer "earned_gold", default: 0, null: false
    t.integer "earned_platinum", default: 0, null: false
    t.text "about_me"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_id"], name: "unique PSN ID", unique: true
    t.index ["user_id"], name: "unique PSN Account", unique: true
  end

  create_table "releases", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "platform_id", null: false
    t.integer "region"
    t.date "date"
    t.integer "trophy_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_releases_on_game_id"
    t.index ["platform_id"], name: "index_releases_on_platform_id"
    t.index ["trophy_list_id"], name: "index_releases_on_trophy_list_id"
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
    t.boolean "unobtainable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trophy_list_id", "psn_id"], name: "unique trophy index", unique: true
    t.index ["trophy_list_id"], name: "index_trophies_on_trophy_list_id"
  end

  create_table "trophy_lists", force: :cascade do |t|
    t.string "name"
    t.string "detail"
    t.string "comm_id", null: false
    t.string "title_id"
    t.string "service", null: false
    t.integer "region"
    t.decimal "version"
    t.string "icon_url", null: false
    t.date "server_shutdown_date"
    t.string "psnp_id"
    t.string "psntl_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comm_id"], name: "unique PSN communication ID index", unique: true
    t.index ["title_id"], name: "unique PSN title ID index", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "account_trophy_lists", "psn_accounts"
  add_foreign_key "account_trophy_lists", "trophy_lists"
  add_foreign_key "earned_trophies", "account_trophy_lists"
  add_foreign_key "earned_trophies", "trophies"
  add_foreign_key "game_statuses", "games"
  add_foreign_key "game_statuses", "users"
  add_foreign_key "platforms", "platform_families"
  add_foreign_key "psn_accounts", "users"
  add_foreign_key "psn_accounts", "users"
  add_foreign_key "releases", "games"
  add_foreign_key "releases", "platforms"
  add_foreign_key "releases", "trophy_lists"
  add_foreign_key "trophies", "trophy_lists"
end
