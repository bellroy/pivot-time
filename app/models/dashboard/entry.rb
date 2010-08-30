class Dashboard::Entry < ActiveRecord::Base
  establish_connection configurations[Rails.env]["events_db"]
  set_table_name "time_entries"
end
