class PivotalEvent::StoryCreate < PivotalEvent::Base
  def affect_story
    self.story = Story.find_or_create_by_id(story_id)
    story.name = activity['stories']['story']['name']['__content__'] rescue nil
    story.story_type = activity['stories']['story']['story_type']['__content__'] rescue nil
    story.state = state
    story.save
  end
end
