class CreatePivotalEvents < ActiveRecord::Migration
  def self.up
    create_table :pivotal_events do |t|
      t.string :type
      t.integer :task_id
      t.datetime :created_at
    end

    add_index :pivotal_events, :type
    add_index :pivotal_events, :task_id
    add_index :pivotal_events, :created_at
  end

  def self.down
    drop_table :pivotal_events
  end
end
