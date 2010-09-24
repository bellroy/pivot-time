require 'slimtimer_api'

module SlimtimerIntegration
  SLIMTIMER_CONFIG = YAML.load_file(File.join(Rails.root, 'config', 'slimtimer.yml'))

  def self.included(base)
    base.class_eval do
      before_create :ensure_slimtimer_user_id
      before_create :create_slimtimer_entry
    end
  end

  def slimtimer
    @slimtimer ||= SlimtimerApi.new(
                     SLIMTIMER_CONFIG['api_key'],
                     SLIMTIMER_CONFIG['email'],
                     SLIMTIMER_CONFIG['password']
                   )
  end

  def create_slimtimer_entry
    #slimtimer
    xml = slimtimer.post '/time_entries', to_slimtimer_yaml
  end

  def to_slimtimer_xml
    xml = Builder::XmlMarkup.new
    xml.instruct!
    xml.tag! 'time-entry' do
      xml.tag! 'start-time', {:type => 'datetime'}, start_time.strftime("%F %R") if start_time
      xml.tag! 'end-time', {:type => 'datetime'}, end_time.strftime("%F %R") if end_time
      xml.tag! 'duration-in-seconds', {:type => 'integer'}, duration_in_seconds
      xml.tag! 'task-id', slimtimer_task_id
      xml.tag! 'comments', comments
      xml.tag! 'in-progress', {:type => 'boolean'}, 'false'
    end
  end

  def to_slimtimer_yaml
    {
      :time_entry => {
        'start_time' => start_time.utc.iso8601,
        'end_time' => end_time.utc.iso8601,
        'duration_in_seconds' => duration_in_seconds,
        'task_id' => slimtimer_task_id,
        'comments' => comments
      }
    }
  end
end
