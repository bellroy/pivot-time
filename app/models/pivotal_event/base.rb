class PivotalEvent::Base < ActiveRecord::Base
  set_table_name :pivotal_events

  belongs_to :story

  validates_presence_of :story_id

  after_create :affect_story

  class << self
    def handle(xml)
      activity = extract_activity(xml)
      event_type = activity['event_type']['__content__']
      klass = "pivotal_event/#{event_type}".classify.constantize
      return klass.handle_activity(activity)
    end

    def handle_activity(activity)
      create(
        :story_id     => activity['stories']['story']['id']['__content__'],
        :created_at   => Time.parse(activity['occurred_at']['__content__']),
        :description  => activity['description']['__content__']
      )
    end

    def extract_activity(xml)
      doc = ActiveSupport::XmlMini.parse(xml)
      return doc['activity']
    end
  end
end
