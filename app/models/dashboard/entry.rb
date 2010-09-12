class Dashboard::Entry < ActiveRecord::Base
  establish_connection configurations[Rails.env]["events_db"]
  set_table_name "time_entries"

  belongs_to :task, :foreign_key => :slimtimer_task_id
end
