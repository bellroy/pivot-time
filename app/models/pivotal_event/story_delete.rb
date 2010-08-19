class PivotalEvent::StoryDelete < PivotalEvent::Base
  def affect_story
    self.story = Story.find_or_create_by_id(story_id)
    story.deleted_at = created_at
    story.save
  end
end
