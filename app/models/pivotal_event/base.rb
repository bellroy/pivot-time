class PivotalEvent::Base < ActiveRecord::Base
  set_table_name :pivotal_events

  belongs_to :task
end
