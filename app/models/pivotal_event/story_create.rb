class PivotalEvent::StoryCreate < PivotalEvent::Base
  class << self
    def handle_activity(activity)
      story = Story.find_or_create_by_id(activity['stories']['story']['id']['__content__'])
      event = create(
        :created_at   => Time.parse(activity['occurred_at']['__content__']),
        :description  => activity['description']['__content__']
      )
      story.pivotal_events << event

      return event
    end
  end
end
