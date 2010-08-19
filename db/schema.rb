# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100705231745) do

  create_table "pivotal_events", :force => true do |t|
    t.string   "type"
    t.integer  "story_id"
    t.datetime "created_at"
    t.text     "description"
  end

  add_index "pivotal_events", ["created_at"], :name => "index_pivotal_events_on_created_at"
  add_index "pivotal_events", ["story_id"], :name => "index_pivotal_events_on_story_id"
  add_index "pivotal_events", ["type"], :name => "index_pivotal_events_on_type"

  create_table "stories", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["type"], :name => "index_stories_on_type"

end
