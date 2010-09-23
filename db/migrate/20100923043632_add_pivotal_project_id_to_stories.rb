class AddPivotalProjectIdToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :pivotal_project_id, :integer, :null => false
    add_index :stories, :pivotal_project_id
  end

  def self.down
    remove_column :stories, :pivotal_project_id
  end
end
