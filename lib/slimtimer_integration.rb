require 'slimtimer_api'

module SlimtimerIntegration
  module Base
    SLIMTIMER_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'slimtimer.yml'))

    def slimtimer
      @slimtimer ||= SlimtimerApi.new(
                       SLIMTIMER_CONFIG['api_key'],
                       SLIMTIMER_CONFIG['email'],
                       SLIMTIMER_CONFIG['password']
                     )
    end
  end

  module Task
    def self.included(base)
      base.class_eval do
        include Base
        before_create :create_slimtimer_task
      end
    end

    def create_slimtimer_task
      response = slimtimer.post '/tasks', to_slimtimer_xml
      self.id = response.parsed_response['task']['id']
    end

    def to_slimtimer_xml
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.task do
        xml.name name
        xml.tags 'trike'
      end
    end
  end

  module Entry
    def self.included(base)
      base.class_eval do
        include Base
        before_create :create_slimtimer_entry
      end
    end

    def create_slimtimer_entry
      response = slimtimer.post '/time_entries', to_slimtimer_xml
      self.id = response.parsed_response['time_entry']['id']
    end

    def to_slimtimer_xml
      xml = Builder::XmlMarkup.new
      xml.instruct!
      xml.tag! 'time-entry' do
        xml.tag! 'start-time', {:type => 'datetime'}, start_time.utc.iso8601 if start_time
        xml.tag! 'end-time', {:type => 'datetime'}, end_time.utc.iso8601 if end_time
        xml.tag! 'duration-in-seconds', {:type => 'integer'}, duration_in_seconds
        xml.tag! 'task-id', slimtimer_task_id
        xml.tag! 'comments', comments
        xml.tag! 'in-progress', {:type => 'boolean'}, 'false'
      end
    end
  end
end
