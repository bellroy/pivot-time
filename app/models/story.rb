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
    elsif tasks.size > 1
      raise "Multiple tasks found - you have a dashboard data problem"
    else
      nil
    end
  end

  def project
    Project.by_pivotal_id(pivotal_project_id)
  end

  def slimtimer_task_name
    if task = dashboard_task
      task.name
    else
      "#{project.slimtimer_task_prefix} #{id}"
    end
  end

  def create_dashboard_task
    Dashboard::Task.create(:name => slimtimer_task_name)
  end

  def find_or_create_dashboard_task
    dashboard_task or create_dashboard_task
  end

  def create_dashboard_event
  end
end
