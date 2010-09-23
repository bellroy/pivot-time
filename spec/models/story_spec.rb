require 'spec_helper'

describe Story do
  before(:each) do
    Project.stub!(:by_pivotal_id).and_return(Project.new(42, 'default_slimtimer_prefix' => 't:pants website'))
  end

  describe "linked dashboard Task," do
    describe "when linked task exists," do
      it "should have dashboard_task" do
        #task = Dashboard::Task.create(:name => "t:prj website 12345")
        Dashboard::Task.stub(:where).and_return([task = mock_model(Dashboard::Task)])

        story = Story.new
        story.id = 12345

        story.dashboard_task.should == task

        task.destroy
      end
    end
    describe "when linked task does not exist," do
      before(:each) do
        @project = Project.new('pants', { 'default_slimtimer_prefix' => 't:pants website' })
        Project.stub(:by_pivotal_id).and_return(@project)
      end

      it "should create linked dashboard_task" do
        story = Story.new
        story.id = 12345
        story.pivotal_project_id = 42

        Dashboard::Task.should_receive(:create).with(:name => 't:pants website 12345')
        story.create_dashboard_task
      end
    end
  end

  describe "inferred event times" do
    event_type = Hash.new(PivotalEvent::StoryUpdate)
    event_type[:create] = PivotalEvent::StoryCreate
    event_type[:delete] = PivotalEvent::StoryDelete

    before do
      @story = Story.create(:pivotal_project_id => 42)
    end

    Story::STATES.each do |action, state|
      it "knows the right story_#{action}'d_at time, given existence of relevant events" do
        a_time = Time.parse("2001-01-01 13:01")
        event_type[action].create(:occurred_at => a_time, :story => @story, :state => state)
        event_type[action].create(:occurred_at => a_time - 10000, :story => @story, :state => state)

        meth = action.to_s.match(/e$/) ? "story_#{action}d_at" : "story_#{action}ed_at"
        @story.send(meth.to_sym).should == a_time
      end
    end
  end

  describe "dashboard integration" do
    it "should not make a dashboard task when it's not started" do
      Dashboard::Task.should_not_receive(:create)
      Story.create(:pivotal_project_id => 42, :state => 'create')
    end

    it "should make an dashboard task when it's started" do
      Dashboard::Task.should_receive(:create)
      Story.create(:pivotal_project_id => 42, :state => 'start')
    end

    it "should not make a dashboard event when it's not delivered or accepted" do
      Dashboard::Task.stub(:where).and_return([task = mock_model(Dashboard::Task)])
      task.stub(:entries).and_return(entries = [])
      entries.should_not_receive(:create_with_zero_time)
      Story.create(:pivotal_project_id => 42, :state => 'start')
    end

    it "should make a dashboard event when it's delivered or accepted" do
      Dashboard::Task.stub(:where).and_return([task = mock_model(Dashboard::Task)])
      task.stub(:entries).and_return(entries = [])
      entries.should_receive(:create_with_zero_time)
      Story.create(:pivotal_project_id => 42, :state => 'deliver')
    end
  end
end
