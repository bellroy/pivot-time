class PivotalEvent::StoryDelete < PivotalEvent::Base
  def affect_story
    self.story = Story.find_or_create_by_id(story_id)
    story.update_attributes(
      :deleted_at => occurred_at,
      :state      => 'deleted'
    )
  end
end
