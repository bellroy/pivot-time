class PivotalEvent::StoryDelete < PivotalEvent::Base
  def affect_story
    self.update_attribute(:state, "deleted")
    self.story = Story.find_or_create_by_pivotal_story_id_and_pivotal_project_id(story_id, project_id)
    story.update_attributes(
      :state      => 'deleted'
    )
  end
end
