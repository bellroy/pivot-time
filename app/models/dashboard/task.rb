class Dashboard::Task < ActiveRecord::Base
  establish_connection configurations[Rails.env]["events_db"]
  set_table_name "slimtimer_tasks"

  has_many :entries, :foreign_key => :slimtimer_task_id
end
