class PivotalEvent::Base < ActiveRecord::Base
  set_table_name :pivotal_events

  belongs_to :story

  class << self
    def handle(xml)
      activity = extract_activity(xml)
      event_type = activity['event_type']['__content__']
      klass = "pivotal_event/#{event_type}".classify.constantize
      return klass.handle_activity(activity)
    end

    def handle_activity(activity)
      raise "You need to override self.handle_activity(activity) in #{self}"
    end

    def extract_activity(xml)
      doc = ActiveSupport::XmlMini.parse(xml)
      return doc['activity']
    end
  end
end
