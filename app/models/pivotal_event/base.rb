class PivotalEvent::Base < ActiveRecord::Base
  set_table_name :pivotal_events

  belongs_to :story

  attr_accessor :activity
  attr_accessor :project_id

  after_create :affect_story
  after_initialize :init_with_activity

  def init_with_activity
    return unless activity

    state = activity['stories']['story']['current_state']['__content__'] rescue nil
    self.attributes = {
      'project_id'  => activity['project_id']['__content__'],
      'story_id'    => activity['stories']['story']['id']['__content__'],
      'occurred_at' => Time.parse(activity['occurred_at']['__content__']),
      'description' => activity['description']['__content__'],
      'state'       => state
    }
  end

  def affect_story
    raise NotImplemented, "Override PivotalEvent::Base#affect_story in #{self.class.name}"
  end

  def self.create_from_xml(xml)
    activity = parse(xml)
    event_type = activity['event_type']['__content__']
    klass = "pivotal_event/#{event_type}".classify.constantize

    event = klass.new(:activity => activity)
    event.save

    event
  end

  def self.parse(xml)
    doc = ActiveSupport::XmlMini.parse(xml)
    return doc['activity']
  end
end
