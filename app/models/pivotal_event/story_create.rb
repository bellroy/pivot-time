class PivotalEvent::StoryCreate < PivotalEvent::Base
  def affect_story
    raise ArgumentError, "StoryCreate requires a story id" if story_id.blank?
    raise ArgumentError, "StoryCreate requires a project id" if project_id.blank?

    self.story = Story.find_or_create_by_pivotal_story_id_and_pivotal_project_id(story_id, project_id)
    story.name = activity['stories']['story']['name']['__content__'] rescue nil
    story.story_type = activity['stories']['story']['story_type']['__content__'] rescue nil
    story.state = state
    story.save
  end
end
