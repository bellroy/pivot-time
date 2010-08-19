class PivotalEvent::StoryUpdate < PivotalEvent::Base
  def affect_story
    self.story = Story.find_or_create_by_id(story_id)
    story.update_attributes(
      :started_at => created_at,
      :state      => 'started'
    )
  end
end
