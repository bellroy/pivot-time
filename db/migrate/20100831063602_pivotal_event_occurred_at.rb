class PivotalEventOccurredAt < ActiveRecord::Migration
  def self.up
    rename_column :pivotal_events, :created_at, :occurred_at
    add_timestamps :pivotal_events
  end

  def self.down
    remove_timestamps :pivotal_events
    rename_column :pivotal_events, :occurred_at, :created_at
  end
end
