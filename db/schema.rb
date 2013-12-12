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

ActiveRecord::Schema.define(:version => 20131212025235) do

  create_table "accounts", :force => true do |t|
    t.string   "no",                                                     :null => false
    t.string   "password",                                               :null => false
    t.string   "server"
    t.integer  "roles_count",                      :default => 0,        :null => false
    t.integer  "computers_count",                  :default => 0,        :null => false
    t.boolean  "normal",                           :default => true,     :null => false
    t.string   "status",                           :default => "normal", :null => false
    t.string   "ip_range"
    t.string   "online_ip"
    t.integer  "online_note_id",                   :default => 0,        :null => false
    t.integer  "online_role_id",                   :default => 0,        :null => false
    t.integer  "online_computer_id",               :default => 0,        :null => false
    t.datetime "created_at",                                             :null => false
    t.datetime "updated_at",                                             :null => false
    t.integer  "bind_computer_id",                 :default => -1,       :null => false
    t.datetime "bind_computer_at"
    t.datetime "normal_at"
    t.integer  "session_id",                       :default => 0,        :null => false
    t.boolean  "today_success",                    :default => false,    :null => false
    t.integer  "current_role_id",                  :default => 0,        :null => false
    t.string   "last_start_ip",      :limit => 32
  end

  add_index "accounts", ["no"], :name => "index_accounts_on_no", :unique => true
  add_index "accounts", ["server"], :name => "index_accounts_on_server"
  add_index "accounts", ["status"], :name => "index_accounts_on_status"

  create_table "computer_accounts", :force => true do |t|
    t.integer  "computer_id", :null => false
    t.string   "account_no",  :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "computer_accounts", ["computer_id", "account_no"], :name => "index_computer_accounts_on_computer_id_and_account_no", :unique => true

  create_table "computers", :force => true do |t|
    t.string   "hostname",                                     :null => false
    t.integer  "user_id",                                      :null => false
    t.string   "auth_key",                                     :null => false
    t.integer  "status",                :default => 1,         :null => false
    t.integer  "roles_count",           :default => 0,         :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "checked",               :default => false,     :null => false
    t.integer  "check_user_id",         :default => 0
    t.datetime "checked_at"
    t.string   "server"
    t.string   "version",               :default => "default", :null => false
    t.integer  "online_roles_count",    :default => 0,         :null => false
    t.boolean  "started",               :default => false,     :null => false
    t.integer  "accounts_count",        :default => 0,         :null => false
    t.integer  "online_accounts_count", :default => 0,         :null => false
    t.integer  "session_id",            :default => 0,         :null => false
    t.boolean  "auto_binding",          :default => true,      :null => false
  end

  create_table "comroles", :force => true do |t|
    t.integer  "role_id",     :default => 0,    :null => false
    t.integer  "computer_id", :default => 0,    :null => false
    t.boolean  "normal",      :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "comroles", ["role_id", "computer_id"], :name => "index_comroles_on_role_id_and_computer_id", :unique => true

  create_table "data_nodes", :force => true do |t|
    t.string   "computers",  :limit => 500, :default => "{}", :null => false
    t.string   "accounts",   :limit => 500, :default => "{}", :null => false
    t.string   "roles",      :limit => 500, :default => "{}", :null => false
    t.string   "events",     :limit => 500, :default => "{}", :null => false
    t.string   "opts",       :limit => 500, :default => "{}", :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "ips", :primary_key => "value", :force => true do |t|
    t.integer  "use_count",    :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
    t.string   "last_account"
  end

  create_table "notes", :force => true do |t|
    t.integer  "user_id",                      :default => 0,     :null => false
    t.integer  "role_id",                      :default => 0,     :null => false
    t.integer  "computer_id",                  :default => 0,     :null => false
    t.string   "ip",             :limit => 15,                    :null => false
    t.string   "api_name",                                        :null => false
    t.string   "api_code",                     :default => "0",   :null => false
    t.string   "action"
    t.string   "msg"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.integer  "online_note_id",               :default => 0,     :null => false
    t.datetime "online_at"
    t.float    "online_hours",                 :default => 0.0,   :null => false
    t.integer  "level"
    t.string   "version"
    t.string   "account"
    t.string   "server"
    t.string   "hostname"
    t.integer  "session_id",                   :default => 0,     :null => false
    t.integer  "sup_id",                       :default => 0,     :null => false
    t.boolean  "effective",                    :default => true,  :null => false
    t.boolean  "ending",                       :default => false, :null => false
    t.boolean  "success",                      :default => false, :null => false
    t.float    "hours",                        :default => 0.0,   :null => false
    t.integer  "gold",                         :default => 0,     :null => false
    t.datetime "started_at"
    t.datetime "stopped_at"
    t.datetime "success_at"
    t.string   "target"
    t.string   "result"
    t.string   "opts"
    t.string   "goods"
    t.integer  "amount",                       :default => 0,     :null => false
    t.integer  "cost",                         :default => 0,     :null => false
    t.string   "role_type"
    t.string   "role_name"
  end

  create_table "payments", :force => true do |t|
    t.integer  "role_id",                   :null => false
    t.integer  "note_id",                   :null => false
    t.integer  "gold",                      :null => false
    t.integer  "balance",                   :null => false
    t.integer  "total",                     :null => false
    t.string   "pay_type",                  :null => false
    t.string   "remark"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "server"
    t.integer  "session_id", :default => 0, :null => false
    t.string   "target"
  end

  create_table "roles", :force => true do |t|
    t.string   "account",                                             :null => false
    t.string   "password",                                            :null => false
    t.integer  "role_index"
    t.string   "server"
    t.integer  "level",                         :default => 0,        :null => false
    t.integer  "vit_power",                     :default => 0,        :null => false
    t.string   "status",                        :default => "normal", :null => false
    t.integer  "computer_id",                   :default => 0,        :null => false
    t.integer  "count",                         :default => 0,        :null => false
    t.boolean  "online",                        :default => false,    :null => false
    t.string   "ip",              :limit => 15
    t.integer  "gold",                          :default => 0
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.boolean  "close",                         :default => false
    t.integer  "close_hours"
    t.datetime "closed_at"
    t.datetime "reopen_at"
    t.integer  "total",                         :default => 0,        :null => false
    t.integer  "total_pay",                     :default => 0,        :null => false
    t.boolean  "locked",                        :default => false,    :null => false
    t.boolean  "lost",                          :default => false,    :null => false
    t.boolean  "is_seller",                     :default => false,    :null => false
    t.string   "ip_range"
    t.integer  "online_note_id",                :default => 0,        :null => false
    t.datetime "online_at"
    t.boolean  "normal",                        :default => true,     :null => false
    t.boolean  "bslocked",                      :default => false,    :null => false
    t.boolean  "unbslock_result"
    t.string   "name"
    t.string   "ip_range2"
    t.integer  "computers_count",               :default => 0,        :null => false
    t.integer  "session_id",                    :default => 0,        :null => false
    t.boolean  "today_success",                 :default => false,    :null => false
    t.integer  "bag_value",                     :default => 0,        :null => false
    t.integer  "start_count",                   :default => 0,        :null => false
    t.integer  "experience",                    :default => 0,        :null => false
    t.string   "task_name"
    t.boolean  "reset_talent",                  :default => false,    :null => false
    t.boolean  "is_agent",                      :default => false,    :null => false
  end

  add_index "roles", ["account"], :name => "index_roles_on_account"

  create_table "servers", :force => true do |t|
    t.string   "name",            :limit => 124,                  :null => false
    t.string   "role_str"
    t.integer  "roles_count",                    :default => 0,   :null => false
    t.integer  "computers_count",                :default => 0,   :null => false
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "goods"
    t.integer  "price",                          :default => 1,   :null => false
    t.float    "gold_price",                     :default => 0.0, :null => false
    t.float    "gold_unit",                      :default => 0.0, :null => false
    t.string   "goods2"
    t.integer  "price2",                         :default => 1,   :null => false
    t.integer  "max_price",                      :default => 1,   :null => false
    t.integer  "max_price2",                     :default => 1,   :null => false
  end

  add_index "servers", ["name"], :name => "index_servers_on_name", :unique => true

  create_table "sessions", :force => true do |t|
    t.integer  "computer_id",                            :default => 0,        :null => false
    t.string   "account"
    t.integer  "role_id",                                :default => 0,        :null => false
    t.integer  "sup_id",                                 :default => 0,        :null => false
    t.string   "ip",                      :limit => 15,                        :null => false
    t.string   "hostname"
    t.string   "server"
    t.string   "version"
    t.string   "game_version"
    t.boolean  "ending",                                 :default => false,    :null => false
    t.datetime "end_at"
    t.float    "hours",                                  :default => 0.0,      :null => false
    t.boolean  "success",                                :default => false,    :null => false
    t.string   "code"
    t.string   "result"
    t.string   "status",                                 :default => "normal", :null => false
    t.integer  "computer_accounts_count",                :default => 0,        :null => false
    t.integer  "account_roles_count",                    :default => 0,        :null => false
    t.string   "account_roles_ids"
    t.integer  "role_start_level",                       :default => 0,        :null => false
    t.integer  "role_end_level",                         :default => 0,        :null => false
    t.integer  "role_start_gold",                        :default => 0,        :null => false
    t.integer  "role_end_gold",                          :default => 0,        :null => false
    t.integer  "trade_gold",                             :default => 0,        :null => false
    t.string   "opts",                    :limit => 500, :default => "{}",     :null => false
    t.string   "events",                  :limit => 500, :default => "{}",     :null => false
    t.string   "msg"
    t.datetime "created_at",                                                   :null => false
    t.datetime "updated_at",                                                   :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "key",                       :null => false
    t.integer  "val",        :default => 1, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "history"
    t.string   "remark"
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

  create_table "tasks", :force => true do |t|
    t.string   "user_id",                        :null => false
    t.integer  "role_id",     :default => 0,     :null => false
    t.integer  "computer_id", :default => 0,     :null => false
    t.integer  "sup_id",      :default => 0,     :null => false
    t.string   "name",                           :null => false
    t.string   "command"
    t.string   "args"
    t.string   "code"
    t.string   "remark"
    t.boolean  "pushed",      :default => false, :null => false
    t.datetime "pushed_at"
    t.boolean  "callback",    :default => false, :null => false
    t.datetime "callback_at"
    t.string   "msg"
    t.boolean  "success",     :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
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
