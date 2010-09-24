require 'slimtimer_integration'

class Dashboard::Task < ActiveRecord::Base
  establish_connection configurations[Rails.env]["events_db"]
  set_table_name "slimtimer_tasks"

  has_many :entries, :foreign_key => :slimtimer_task_id

  include SlimtimerIntegration::Task

  def create_blank_entry
    entries.create!(
      :start_time => Time.now,
      :end_time => Time.now,
      :duration_in_seconds => 1,
      :comments => "Automatically created by pivot-time"
    )
  end
end
