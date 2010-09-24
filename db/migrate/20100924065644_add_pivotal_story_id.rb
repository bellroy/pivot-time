class AddPivotalStoryId < ActiveRecord::Migration
  def self.up
    add_column :stories, :pivotal_story_id, :integer, :null => false
    add_index :stories, :pivotal_story_id
  end

  def self.down
    remove_column :stories, :pivotal_story_id
  end
end
