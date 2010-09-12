class Story < ActiveRecord::Base
  has_many :pivotal_events, :class_name => 'PivotalEvent::Base', :dependent => :destroy

  STATES = {
    :create     => :unscheduled,
    :schedule   => :unstarted,
    :unschedule => :unscheduled,
    :start      => :started,
    :finish     => :finished,
    :deliver    => :delivered,
    :accept     => :accepted,
    :reject     => :rejected,
    :restart    => :restarted,
    :unstart    => :unstarted,
    :delete     => :deleted
  }
  
  STATES.each do |action, state|
    meth = action.to_s.match(/e$/) ? "story_#{action}d_at" : "story_#{action}ed_at"
    define_method(meth) do
      event = pivotal_events.where(:state => state).order(:occurred_at).last
      event.occurred_at if event
    end
  end
end
