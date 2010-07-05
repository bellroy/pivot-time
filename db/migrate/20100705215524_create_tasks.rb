class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.string :type
      t.string :name

      t.timestamps
    end

    add_index :tasks, :type
  end

  def self.down
    drop_table :tasks
  end
end
