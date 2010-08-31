class RenameStoryTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :stories, :type, :story_type
  end

  def self.down
    rename_column :stories, :story_type, :type
  end
end
