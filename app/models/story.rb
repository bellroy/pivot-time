class Story < ActiveRecord::Base
  has_many :pivotal_events, :class_name => 'PivotalEvent::Base', :dependent => :destroy
  # has_many :dashboard_tasks

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

  def dashboard_task
    tasks = Dashboard::Task.where("name like '%#{id}%'")
    if tasks.size == 1
      tasks.first
    else
      raise "Multiple tasks found - you have a dashboard data problem"
    end
  end
end
