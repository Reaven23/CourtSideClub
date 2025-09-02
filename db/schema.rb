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

ActiveRecord::Schema[7.1].define(version: 2025_09_02_123833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "content", null: false
    t.boolean "correct", default: false, null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id", "order"], name: "index_answers_on_question_id_and_order", unique: true
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "article_tags", force: :cascade do |t|
    t.bigint "article_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id", "tag_id"], name: "index_article_tags_on_article_id_and_tag_id", unique: true
    t.index ["article_id"], name: "index_article_tags_on_article_id"
    t.index ["tag_id"], name: "index_article_tags_on_tag_id"
  end

  create_table "articles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.text "content"
    t.string "youtube_embed"
    t.string "instagram_embed"
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["published_at"], name: "index_articles_on_published_at"
    t.index ["user_id", "published_at"], name: "index_articles_on_user_id_and_published_at"
    t.index ["user_id"], name: "index_articles_on_user_id"
  end

  create_table "levels", force: :cascade do |t|
    t.integer "number"
    t.bigint "points"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.string "object"
    t.text "content"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status"
    t.string "phone"
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "email"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "players", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "tournament_played"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "quiz_game_id", null: false
    t.text "content", null: false
    t.integer "order", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_game_id", "order"], name: "index_questions_on_quiz_game_id_and_order", unique: true
    t.index ["quiz_game_id"], name: "index_questions_on_quiz_game_id"
  end

  create_table "quiz_games", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "points_per_question", default: 1, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "color", default: "#ee53a8"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_question_answers", force: :cascade do |t|
    t.bigint "user_quiz_game_id", null: false
    t.bigint "question_id", null: false
    t.bigint "answer_id", null: false
    t.boolean "correct", default: false, null: false
    t.datetime "answered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_user_question_answers_on_answer_id"
    t.index ["question_id"], name: "index_user_question_answers_on_question_id"
    t.index ["user_quiz_game_id", "question_id"], name: "index_user_question_answers_unique", unique: true
    t.index ["user_quiz_game_id"], name: "index_user_question_answers_on_user_quiz_game_id"
  end

  create_table "user_quiz_games", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_game_id", null: false
    t.integer "score", default: 0
    t.boolean "completed", default: false, null: false
    t.integer "points_earned", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_game_id"], name: "index_user_quiz_games_on_quiz_game_id"
    t.index ["user_id", "completed"], name: "index_user_quiz_games_on_user_id_and_completed"
    t.index ["user_id"], name: "index_user_quiz_games_on_user_id"
  end

  create_table "user_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "vote_campaign_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_user_votes_on_player_id"
    t.index ["user_id", "vote_campaign_id"], name: "index_user_votes_unique", unique: true
    t.index ["user_id"], name: "index_user_votes_on_user_id"
    t.index ["vote_campaign_id"], name: "index_user_votes_on_vote_campaign_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.date "birthdate"
    t.integer "points", default: 0, null: false
    t.bigint "level_id"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["level_id"], name: "index_users_on_level_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vote_campaign_players", force: :cascade do |t|
    t.bigint "vote_campaign_id", null: false
    t.bigint "player_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_vote_campaign_players_on_player_id"
    t.index ["vote_campaign_id", "player_id"], name: "index_vote_campaign_players_unique", unique: true
    t.index ["vote_campaign_id"], name: "index_vote_campaign_players_on_vote_campaign_id"
  end

  create_table "vote_campaigns", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_vote_campaigns_on_active"
    t.index ["end_date"], name: "index_vote_campaigns_on_end_date"
    t.index ["start_date"], name: "index_vote_campaigns_on_start_date"
  end

  create_table "votes", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_votes_on_player_id"
    t.index ["user_id", "player_id"], name: "index_votes_on_user_id_and_player_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "article_tags", "articles"
  add_foreign_key "article_tags", "tags"
  add_foreign_key "articles", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "questions", "quiz_games"
  add_foreign_key "user_question_answers", "answers"
  add_foreign_key "user_question_answers", "questions"
  add_foreign_key "user_question_answers", "user_quiz_games"
  add_foreign_key "user_quiz_games", "quiz_games"
  add_foreign_key "user_quiz_games", "users"
  add_foreign_key "user_votes", "players"
  add_foreign_key "user_votes", "users"
  add_foreign_key "user_votes", "vote_campaigns"
  add_foreign_key "users", "levels"
  add_foreign_key "vote_campaign_players", "players"
  add_foreign_key "vote_campaign_players", "vote_campaigns"
  add_foreign_key "votes", "players"
  add_foreign_key "votes", "users"
end
