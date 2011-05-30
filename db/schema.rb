# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110227225207) do

  create_table "authentications", :force => true do |t|
    t.integer "user_id"
    t.string  "provider"
    t.string  "uid"
  end

  create_table "documents", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "file"
    t.integer  "user_id"
    t.string   "content_type"
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "documents", ["user_id"], :name => "index_documents_on_user_id"

  create_table "group_documents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "document_id"
    t.integer  "group_module_id"
    t.boolean  "pending",         :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_documents", ["group_id", "document_id"], :name => "index_group_documents_on_group_id_and_document_id"

  create_table "group_members", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_members", ["group_id", "user_id"], :name => "index_group_members_on_group_id_and_user_id"

  create_table "group_modules", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_modules", ["group_id"], :name => "index_group_modules_on_group_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "cached_slug"
    t.string   "image"
    t.string   "status"
    t.integer  "modules_count",   :default => 0
    t.integer  "members_count",   :default => 0
    t.integer  "documents_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.boolean  "blocked",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "updates", :force => true do |t|
    t.integer  "creator_id"
    t.string   "creator_type"
    t.integer  "target_id"
    t.string   "target_type"
    t.string   "custom_message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "updates", ["creator_type", "creator_id", "target_type", "target_id"], :name => "index_updates_on_c_and_t"

  create_table "user_documents", :force => true do |t|
    t.integer  "user_id"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_documents", ["user_id", "document_id"], :name => "index_user_documents_on_user_id_and_document_id"

  create_table "users", :force => true do |t|
    t.string   "login",                                                 :null => false
    t.string   "name",                                                  :null => false
    t.string   "status"
    t.string   "cached_slug"
    t.string   "location"
    t.string   "website"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "image"
    t.text     "description"
    t.boolean  "show_email",                          :default => true
    t.string   "email",                               :default => "",   :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
