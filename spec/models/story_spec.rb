require 'spec_helper'

describe Story do
  describe "linked dashboard Task," do
    describe "when linked task exists," do
      it "should have dashboard_task"
    end
    describe "when linked task does not exist," do
      it "should create linked dashboard_task"
    end
  end

  describe "inferred event times" do
    event_type = Hash.new(PivotalEvent::StoryUpdate)
    event_type[:create] = PivotalEvent::StoryCreate
    event_type[:delete] = PivotalEvent::StoryDelete

    before do
      @story = Story.create
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
end
