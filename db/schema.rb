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

ActiveRecord::Schema.define(:version => 20150327143658) do

  create_table "account_sessions", :force => true do |t|
    t.string   "account_id"
    t.integer  "role_session_id"
    t.string   "ip",              :limit => 16
    t.string   "ip_c",            :limit => 16
    t.string   "started_status"
    t.datetime "finished_at"
    t.datetime "lived_at"
    t.boolean  "finished"
    t.string   "finished_status"
    t.string   "remark"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "computer_id"
    t.integer  "start_count",                   :default => 0
  end

  add_index "account_sessions", ["account_id"], :name => "index_account_sessions_on_account_id"
  add_index "account_sessions", ["computer_id"], :name => "index_account_sessions_on_computer_id"
  add_index "account_sessions", ["created_at"], :name => "index_account_sessions_on_created_at"
  add_index "account_sessions", ["finished", "account_id"], :name => "index_account_sessions_on_finished_and_account_id"
  add_index "account_sessions", ["finished"], :name => "index_account_sessions_on_finished"
  add_index "account_sessions", ["finished"], :name => "index_account_sessions_on_finished_and_computer_name"
  add_index "account_sessions", ["finished_status"], :name => "index_account_sessions_on_finished_status"
  add_index "account_sessions", ["ip"], :name => "index_account_sessions_on_ip"
  add_index "account_sessions", ["ip_c"], :name => "index_account_sessions_on_ip_c"
  add_index "account_sessions", ["lived_at"], :name => "index_account_sessions_on_lived_at"
  add_index "account_sessions", ["start_count"], :name => "index_account_sessions_on_start_count"
  add_index "account_sessions", ["started_status"], :name => "index_account_sessions_on_started_status"

  create_table "account_statuses", :force => true do |t|
    t.string   "status",     :default => "0"
    t.integer  "hours",      :default => 0
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "account_statuses", ["status"], :name => "index_account_statuses_on_status", :unique => true

  create_table "account_tasks", :force => true do |t|
    t.string   "account",                         :null => false
    t.string   "task",       :default => "",      :null => false
    t.string   "event",      :default => "",      :null => false
    t.string   "status",     :default => "doing", :null => false
    t.string   "result",     :default => "",      :null => false
    t.string   "msg"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

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
    t.string   "remark"
    t.boolean  "is_auto",                          :default => false,    :null => false
    t.string   "phone_id"
    t.integer  "phone_event_count",                :default => 0
    t.string   "unlock_phone_id",    :limit => 16
    t.datetime "unlocked_at"
    t.boolean  "rms_file",                         :default => true,     :null => false
    t.boolean  "in_cpo",                           :default => false,    :null => false
    t.boolean  "enabled",                          :default => true,     :null => false
    t.datetime "last_start_at"
    t.boolean  "standing",                         :default => false,    :null => false
    t.integer  "money_point",                      :default => 0
  end

  add_index "accounts", ["no"], :name => "index_accounts_on_no", :unique => true
  add_index "accounts", ["server"], :name => "index_accounts_on_server"
  add_index "accounts", ["status"], :name => "index_accounts_on_status"

  create_table "bot_versions", :id => false, :force => true do |t|
    t.string   "version"
    t.string   "game_versions"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bot_versions", ["version"], :name => "index_bot_versions_on_version"

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
    t.string   "group"
    t.integer  "client_count",          :default => 0,         :null => false
    t.integer  "max_accounts",          :default => 0,         :null => false
    t.integer  "max_roles",             :default => 0,         :null => false
    t.boolean  "allowed_new",           :default => true,      :null => false
    t.string   "real_name"
    t.boolean  "auto_unbind",           :default => true,      :null => false
    t.string   "msg"
  end

  create_table "comroles", :force => true do |t|
    t.integer  "role_id",     :default => 0,    :null => false
    t.integer  "computer_id", :default => 0,    :null => false
    t.boolean  "normal",      :default => true, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "comroles", ["role_id", "computer_id"], :name => "index_comroles_on_role_id_and_computer_id", :unique => true

  create_table "daily_records", :id => false, :force => true do |t|
    t.date     "date"
    t.integer  "account_start_count",    :default => 0
    t.string   "role_start_count",       :default => "0"
    t.integer  "success_role_count",     :default => 0
    t.integer  "consumed_vit_power_sum", :default => 0
    t.integer  "role_online_hours",      :default => 0
    t.integer  "gold",                   :default => 0
    t.integer  "trade_gold",             :default => 0
    t.integer  "bslocked_count",         :default => 0
    t.integer  "discardforyears_count",  :default => 0
    t.integer  "discardfordays_count",   :default => 0
    t.integer  "exception_count",        :default => 0
    t.integer  "recycle_count",          :default => 0
    t.integer  "locked_count",           :default => 0
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.integer  "average_level",          :default => 0
  end

  add_index "daily_records", ["date"], :name => "index_daily_records_on_date", :unique => true

  create_table "data_nodes", :force => true do |t|
    t.string   "computers",  :limit => 500, :default => "{}", :null => false
    t.string   "accounts",   :limit => 500, :default => "{}", :null => false
    t.string   "roles",      :limit => 500, :default => "{}", :null => false
    t.string   "events",     :limit => 500, :default => "{}", :null => false
    t.string   "opts",       :limit => 500, :default => "{}", :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
    t.datetime "marked_at",                                   :null => false
    t.string   "source",                    :default => "",   :null => false
    t.text     "data",                                        :null => false
  end

  create_table "history_role_sessions", :force => true do |t|
    t.datetime "begin_at"
    t.datetime "end_at"
    t.integer  "gold"
    t.integer  "exchanged_gold"
    t.integer  "connection_times"
    t.string   "ip"
    t.string   "task"
    t.string   "result"
    t.integer  "role_id"
    t.integer  "account_id"
    t.integer  "computer_id"
    t.string   "role_name"
    t.string   "computer_name"
    t.integer  "begin_level"
    t.integer  "end_level"
    t.integer  "begin_power"
    t.integer  "end_power"
    t.string   "account_key"
    t.string   "server"
    t.string   "version"
    t.string   "game_version"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "account_session_id"
  end

  add_index "history_role_sessions", ["account_id"], :name => "index_history_role_sessions_on_account_id"
  add_index "history_role_sessions", ["account_session_id"], :name => "index_history_role_sessions_on_account_session_id"
  add_index "history_role_sessions", ["computer_id"], :name => "index_history_role_sessions_on_computer_id"
  add_index "history_role_sessions", ["role_id"], :name => "index_history_role_sessions_on_role_id"

  create_table "instance_maps", :force => true do |t|
    t.integer  "key",                                            :null => false
    t.string   "name",         :limit => 64,                     :null => false
    t.integer  "min_level",                                      :null => false
    t.integer  "max_level",                                      :null => false
    t.integer  "gold",                        :default => 0,     :null => false
    t.integer  "exp",                         :default => 0,     :null => false
    t.boolean  "enabled",                     :default => true,  :null => false
    t.integer  "safety_limit",                                   :null => false
    t.integer  "death_limit",                                    :null => false
    t.integer  "enter_count",                 :default => 0,     :null => false
    t.string   "remark",       :limit => 128
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.boolean  "ishell",                      :default => false, :null => false
  end

  create_table "ip_filters", :force => true do |t|
    t.string   "regex"
    t.boolean  "enabled"
    t.boolean  "reverse"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "ip_ranges", :force => true do |t|
    t.string   "ip",                                         :null => false
    t.integer  "start_count"
    t.integer  "minutes"
    t.integer  "online_count"
    t.integer  "ip_accounts_in_24_hours"
    t.boolean  "enabled",                 :default => false, :null => false
    t.string   "remark"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "ips", :id => false, :force => true do |t|
    t.string   "value",        :limit => 15,                :null => false
    t.integer  "use_count",                  :default => 0, :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "last_account"
    t.datetime "cooling_time"
  end

  add_index "ips", ["cooling_time"], :name => "index_ips_on_cooling_time"
  add_index "ips", ["value"], :name => "index_ips_on_value", :unique => true

  create_table "links", :force => true do |t|
    t.string   "phone_no",            :limit => 32,                     :null => false
    t.string   "event",               :limit => 32,                     :null => false
    t.string   "status",              :limit => 32, :default => "idle", :null => false
    t.string   "link_type",           :limit => 32, :default => "send", :null => false
    t.integer  "sms_count",                         :default => 0,      :null => false
    t.integer  "today_sms_count",                   :default => 0,      :null => false
    t.integer  "timeout_count",                     :default => 0,      :null => false
    t.integer  "today_timeout_count",               :default => 0,      :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
    t.boolean  "enabled",                           :default => true,   :null => false
  end

  add_index "links", ["phone_no", "event"], :name => "index_links_on_phone_no_and_event", :unique => true

  create_table "notes", :id => false, :force => true do |t|
    t.integer  "id",                                              :null => false
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

  add_index "notes", ["account"], :name => "index_notes_on_account"
  add_index "notes", ["computer_id"], :name => "index_notes_on_computer_id"
  add_index "notes", ["role_id"], :name => "index_notes_on_role_id"
  add_index "notes", ["session_id"], :name => "index_notes_on_session_id"

  create_table "orders", :force => true do |t|
    t.string   "phone_no"
    t.string   "account_no"
    t.boolean  "pulled",                       :default => false, :null => false
    t.boolean  "sent",                         :default => false, :null => false
    t.boolean  "finished",                     :default => false, :null => false
    t.datetime "pulled_at"
    t.datetime "sent_at"
    t.datetime "finished_at"
    t.string   "trigger_event"
    t.string   "status"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "result",        :limit => 64
    t.string   "msg",           :limit => 128
    t.string   "sms"
    t.integer  "link_id",                      :default => 0
    t.string   "target_no"
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

  add_index "payments", ["role_id", "note_id"], :name => "index_payments_on_role_id_and_note_id"

  create_table "phone_machines", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "phone_machines", ["name"], :name => "index_phone_machines_on_name", :unique => true

  create_table "phone_tasks", :force => true do |t|
    t.string   "phone_id"
    t.string   "target"
    t.string   "action"
    t.string   "msg"
    t.string   "status",     :default => "waiting"
    t.string   "result"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "phone_tasks", ["action"], :name => "index_phone_tasks_on_action"
  add_index "phone_tasks", ["phone_id"], :name => "index_phone_tasks_on_phone_id"
  add_index "phone_tasks", ["status"], :name => "index_phone_tasks_on_status"

  create_table "phones", :primary_key => "no", :force => true do |t|
    t.boolean  "enabled",          :default => true,   :null => false
    t.datetime "last_active_at"
    t.integer  "phone_machine_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "accounts_count",   :default => 0,      :null => false
    t.boolean  "can_bind",         :default => true,   :null => false
    t.string   "status",           :default => "idle"
    t.integer  "sms_count",        :default => 0,      :null => false
    t.integer  "today_sms_count",  :default => 0,      :null => false
    t.boolean  "can_unlock",       :default => true,   :null => false
    t.integer  "unlock_count",     :default => 0,      :null => false
    t.string   "iccid"
    t.boolean  "online",           :default => false
  end

  add_index "phones", ["iccid"], :name => "index_phones_on_iccid"
  add_index "phones", ["no"], :name => "index_phones_on_no", :unique => true
  add_index "phones", ["online"], :name => "index_phones_on_online"

  create_table "role_profiles", :force => true do |t|
    t.string   "name"
    t.text     "data"
    t.integer  "roles_count", :default => 0
    t.integer  "version",     :default => 1
    t.string   "remark"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "role_profiles", ["name"], :name => "index_role_profiles_on_name", :unique => true

  create_table "role_sessions", :force => true do |t|
    t.integer  "role_id"
    t.integer  "computer_id"
    t.integer  "instance_map_id",    :default => 0
    t.integer  "start_level"
    t.integer  "start_gold"
    t.integer  "start_exp"
    t.string   "ip"
    t.integer  "used_gold",          :default => 0
    t.integer  "exchanged_gold",     :default => 0
    t.string   "task"
    t.integer  "connection_times",   :default => 0
    t.datetime "live_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.integer  "start_power"
    t.integer  "account_session_id"
  end

  add_index "role_sessions", ["account_session_id"], :name => "index_role_sessions_on_account_session_id"
  add_index "role_sessions", ["role_id"], :name => "index_role_sessions_on_role_id"

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
    t.boolean  "is_helper",                     :default => false,    :null => false
    t.integer  "channel_index",                 :default => -1,       :null => false
    t.boolean  "ishell",                        :default => false,    :null => false
    t.string   "profession",                    :default => "",       :null => false
    t.integer  "role_profile_id",               :default => 1
    t.integer  "bag_value",                     :default => 0,        :null => false
    t.integer  "start_count",                   :default => 0,        :null => false
    t.integer  "experience",                    :default => 0,        :null => false
    t.string   "task_name"
    t.boolean  "reset_talent",                  :default => false,    :null => false
    t.boolean  "is_agent",                      :default => false,    :null => false
  end

  add_index "roles", ["account"], :name => "index_roles_on_account"
  add_index "roles", ["role_profile_id"], :name => "index_roles_on_role_profile_id"

  create_table "servers", :force => true do |t|
    t.string   "name",            :limit => 124,                    :null => false
    t.string   "role_str"
    t.integer  "roles_count",                    :default => 0,     :null => false
    t.integer  "computers_count",                :default => 0,     :null => false
    t.datetime "created_at",                                        :null => false
    t.datetime "updated_at",                                        :null => false
    t.string   "goods"
    t.integer  "price",                          :default => 1,     :null => false
    t.float    "gold_price",                     :default => 0.0,   :null => false
    t.float    "gold_unit",                      :default => 0.0,   :null => false
    t.boolean  "allowed_new",                    :default => true,  :null => false
    t.integer  "point",                          :default => 0,     :null => false
    t.string   "goods2"
    t.integer  "price2",                         :default => 1,     :null => false
    t.integer  "max_price",                      :default => 1,     :null => false
    t.integer  "max_price2",                     :default => 1,     :null => false
    t.string   "goods3"
    t.integer  "price3",                         :default => 1,     :null => false
    t.integer  "max_price3",                     :default => 1,     :null => false
    t.boolean  "sell_closed",                    :default => false
    t.boolean  "agent_closed",                   :default => false, :null => false
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

  create_table "support_roles", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "server",     :null => false
    t.string   "line"
    t.string   "status"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "user_id",                                      :null => false
    t.integer  "role_id",                   :default => 0,     :null => false
    t.integer  "computer_id",               :default => 0,     :null => false
    t.integer  "sup_id",                    :default => 0,     :null => false
    t.string   "name",                                         :null => false
    t.string   "command"
    t.string   "args"
    t.string   "code"
    t.string   "remark"
    t.boolean  "pushed",                    :default => false, :null => false
    t.datetime "pushed_at"
    t.boolean  "callback",                  :default => false, :null => false
    t.datetime "callback_at"
    t.string   "msg"
    t.boolean  "success",                   :default => false, :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.string   "account_no",  :limit => 32
    t.datetime "log_at"
  end

  create_table "ticket_records", :force => true do |t|
    t.string   "account",                   :null => false
    t.string   "server"
    t.integer  "role_id"
    t.string   "role_name"
    t.integer  "points",     :default => 0, :null => false
    t.integer  "gold",       :default => 0, :null => false
    t.string   "msg"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
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
