require 'spec_helper'

describe PivotalEvent::StoryCreate do
  describe "handling XML posts" do
    describe "a pivotal event and its story," do
      before do
        @time = "2010/06/27 22:09:44 UTC"
        @desc = %(Peter Hollows added "make it work on Webkit")
        @xml = ERB.new(
          File.read("#{Rails.root}/spec/fixtures/pivotal/story_create.xml.erb")
        ).result(binding)

        @event = PivotalEvent::Base.create_from_xml(@xml)
      end

      it "associates itself with a story with the right name" do
        @event.story.name.should == "a name"
      end

      it "associates itself with a story with the right story_type" do
        @event.story.story_type.should == "feature"
      end
      
      it "records when the story was created" do
        @event.story.created_at.should == Time.parse(@time)
      end

      it "marks the story as unscheduled" do
        @event.story.state.should == 'unscheduled'
      end
    end
  end
end
