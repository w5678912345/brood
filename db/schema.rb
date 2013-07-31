# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130731014357) do

  create_table "computers", :force => true do |t|
    t.string   "hostname",                         :null => false
    t.integer  "user_id",                          :null => false
    t.string   "auth_key",                         :null => false
    t.integer  "status",        :default => 1,     :null => false
    t.integer  "roles_count",   :default => 0,     :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.boolean  "checked",       :default => false, :null => false
    t.integer  "check_user_id", :default => 0
    t.datetime "checked_at"
    t.string   "server"
  end

  create_table "ips", :primary_key => "value", :force => true do |t|
    t.integer  "use_count",  :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id",                   :default => 0,   :null => false
    t.integer  "role_id",                   :default => 0,   :null => false
    t.integer  "computer_id",               :default => 0,   :null => false
    t.string   "ip",          :limit => 15,                  :null => false
    t.string   "api_name",                                   :null => false
    t.string   "api_code",                  :default => "0", :null => false
    t.string   "action"
    t.string   "msg"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "role_id",    :null => false
    t.integer  "note_id",    :null => false
    t.integer  "gold",       :null => false
    t.integer  "balance",    :null => false
    t.integer  "total",      :null => false
    t.string   "pay_type",   :null => false
    t.string   "remark"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "account",                                      :null => false
    t.string   "password",                                     :null => false
    t.integer  "role_index"
    t.string   "server"
    t.integer  "level",                     :default => 0,     :null => false
    t.integer  "vit_power",                 :default => 0,     :null => false
    t.integer  "status",                    :default => 1,     :null => false
    t.integer  "computer_id",               :default => 0,     :null => false
    t.integer  "count",                     :default => 0,     :null => false
    t.boolean  "online",                    :default => false, :null => false
    t.string   "ip",          :limit => 15
    t.integer  "gold",                      :default => 0
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "close",                     :default => false
    t.integer  "close_hours"
    t.datetime "closed_at"
    t.datetime "reopen_at"
    t.integer  "total",                     :default => 0,     :null => false
    t.integer  "total_pay",                 :default => 0,     :null => false
    t.boolean  "locked",                    :default => false, :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key",                       :null => false
    t.integer  "val",        :default => 1, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "sheets", :force => true do |t|
    t.integer  "uploader_id",                     :null => false
    t.integer  "importer_id"
    t.string   "file",                            :null => false
    t.string   "remark"
    t.boolean  "imported",     :default => false, :null => false
    t.datetime "imported_at"
    t.integer  "import_count", :default => 0,     :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "is_admin",               :default => false, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "no"
    t.string   "zip",                                :null => false
    t.integer  "user_id",                            :null => false
    t.boolean  "released",        :default => false, :null => false
    t.time     "released_at"
    t.integer  "release_user_id"
    t.boolean  "release_lock",    :default => false
    t.string   "remark"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "versions", ["no"], :name => "index_versions_on_no", :unique => true

end
