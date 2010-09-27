require 'spec_helper'

describe PivotalEvent::Base do
  describe "handling XML posts" do

    shared_examples_for "a pivotal event" do
      describe "and its story" do
        it "associates itself with a story" do
          @event.story.should be_present
        end

        it "associates itself with a story with the same ID as the Pivotal Tracker story" do
          @event.story.pivotal_story_id.should == 1234
        end
      end

      it "records the message sent in the Pivotal XML" do
        @event.description.should == @desc
      end

      it "records the time the event took place" do
        @event.occurred_at.should == Time.parse(@time)
      end

      it "makes an associated Dashboard::Entry"

      # TODO
      #it "serializes the handled XML"
    end

    describe "to create a story" do
      before do
        @time = "2010/06/27 22:09:44 UTC"
        @desc = %(Peter Hollows added "make it work on Webkit")
        @xml = ERB.new(
          File.read("#{Rails.root}/spec/fixtures/pivotal/story_create.xml.erb")
        ).result(binding)

        @event = PivotalEvent::Base.create_from_xml(@xml)
      end

      it_should_behave_like "a pivotal event"

      it "creates a new StoryCreate pivotal event" do
        @event.class.should == PivotalEvent::StoryCreate
      end
    end

    describe "to delete a story" do
      before do
        @time = "2010/03/27 21:09:44 UTC"
        @desc = %(Peter Hollows deleted "Cart manipulation should be done with Silverlight")
        @xml = ERB.new(
          File.read("#{Rails.root}/spec/fixtures/pivotal/story_delete.xml.erb")
        ).result(binding)

        @story = Story.make(:id => 1234, :pivotal_project_id => 1337, :pivotal_story_id => 1234)
        @event = PivotalEvent::Base.create_from_xml(@xml)
      end

      it_should_behave_like "a pivotal event"

      it "creates a new StoryDelete pivotal event" do
        @event.class.should == PivotalEvent::StoryDelete
      end
    end

    %w(start finish restart reject accept deliver).each do |state|
      describe "to #{state} a story" do
        before do
          @time   = "2010/03/27 18:09:44 UTC"
          @state  = "#{state}ed"
          @desc   = %(Peter Hollows #{@state} "a difficult story")
          @xml = ERB.new(
            File.read("#{Rails.root}/spec/fixtures/pivotal/story_update.xml.erb")
          ).result(binding)

          @story = Story.make(:id => 1234, :pivotal_project_id => 1337, :pivotal_story_id => 1234)
          @event = PivotalEvent::Base.create_from_xml(@xml)
        end

        it_should_behave_like "a pivotal event"

        it "creates a new StoryUpdate pivotal event" do
          @event.class.should == PivotalEvent::StoryUpdate
        end
      end
    end

  end
end
