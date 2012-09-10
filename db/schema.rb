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

ActiveRecord::Schema.define(:version => 20120906093428) do

  create_table "assignments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deliverable_component_subcriptions", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "deliverable_components", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_active",                  :default => false
    t.integer  "deliverable_id"
    t.boolean  "is_production_element",      :default => true
    t.boolean  "is_post_production_element", :default => true
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "deliverable_items", :force => true do |t|
    t.integer  "project_id"
    t.integer  "deliverable_id"
    t.integer  "sub_item_quantity"
    t.text     "project_specific_description"
    t.boolean  "is_basic_deliverable",         :default => true
    t.boolean  "is_active",                    :default => true
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
  end

  create_table "deliverable_subcriptions", :force => true do |t|
    t.integer  "package_id"
    t.integer  "deliverable_id"
    t.boolean  "is_active",      :default => true
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  create_table "deliverables", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "has_sub_item",      :default => false
    t.string   "sub_item_name"
    t.integer  "sub_item_quantity"
    t.boolean  "is_active",         :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "drafts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "packages", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.boolean  "is_active",   :default => true
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "project_assignments", :force => true do |t|
    t.integer  "project_membership_id"
    t.integer  "project_role_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  create_table "project_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "title"
    t.integer  "package_id"
    t.integer  "client_id"
    t.integer  "creator_id"
    t.boolean  "is_fixed_date",                        :default => false
    t.string   "shoot_location"
    t.date     "shoot_date"
    t.date     "shoot_start_date"
    t.date     "shoot_end_date"
    t.date     "internal_deadline"
    t.date     "external_deadline"
    t.boolean  "is_membership_assignment_finalized",   :default => false
    t.date     "membership_assignment_finalized_date"
    t.boolean  "is_deleted",                           :default => false
    t.integer  "deleter_id"
    t.boolean  "is_finished",                          :default => false
    t.integer  "finisher_id"
    t.date     "finish_date"
    t.integer  "score",                                :default => 0
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "name"
    t.boolean  "is_main_user",           :default => false
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
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
