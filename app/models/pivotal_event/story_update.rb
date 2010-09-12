class PivotalEvent::StoryUpdate < PivotalEvent::Base
  def affect_story
    self.story = Story.find_or_create_by_id(story_id)
    story.update_attributes(
      :state      => state
    )
  end
end
