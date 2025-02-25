ActiveRecord::Schema[7.1].define(version: 2025_02_20_095753) do
  create_table "comments", force: :cascade do |t|
    t.text "data"
    t.integer "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
