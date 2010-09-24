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

ActiveRecord::Schema.define(:version => 20100924065644) do

  create_table "pivotal_events", :force => true do |t|
    t.string   "type"
    t.integer  "story_id"
    t.string   "state"
    t.datetime "occurred_at"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pivotal_events", ["occurred_at"], :name => "index_pivotal_events_on_created_at"
  add_index "pivotal_events", ["state"], :name => "index_pivotal_events_on_state"
  add_index "pivotal_events", ["story_id"], :name => "index_pivotal_events_on_story_id"
  add_index "pivotal_events", ["type"], :name => "index_pivotal_events_on_type"

  create_table "stories", :force => true do |t|
    t.string   "story_type"
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pivotal_project_id", :null => false
    t.integer  "pivotal_story_id",   :null => false
  end

  add_index "stories", ["pivotal_project_id"], :name => "index_stories_on_pivotal_project_id"
  add_index "stories", ["pivotal_story_id"], :name => "index_stories_on_pivotal_story_id"
  add_index "stories", ["state"], :name => "index_stories_on_state"
  add_index "stories", ["story_type"], :name => "index_stories_on_type"

  create_table "tasks", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tasks", ["type"], :name => "index_tasks_on_type"

end
