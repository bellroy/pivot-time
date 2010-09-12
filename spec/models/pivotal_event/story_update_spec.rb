require 'spec_helper'

describe PivotalEvent::StoryUpdate do
  describe "handling XML posts" do
    describe "a pivotal event and its story," do
      before do
        @time = "2010/06/27 22:09:44 UTC"
        @desc = %(Peter Hollows added "make it work on Webkit")
      end

      %w(started finished restarted rejected accepted delivered).each do |state|
        describe "to #{state} a story" do
          it "marks the story as #{state}" do
            build_xml(state)
            @event.story.state.should == state
          end

          it "records the right #{state}_at time" do
            build_xml(state)
            @event.story.send(:"#{state}_at").should == Time.parse(@time)
          end
        end
      end

      describe "set story state to unstarted" do
        it "marks the story as unstarted" do
          build_xml("unstarted")
          @event.story.state.should == "unstarted"
        end

        it "records the right ..._at time" do
          build_xml("unstarted")
          @event.story.started_at.should == Time.parse(@time)
        end
      end


      def build_xml(state)
        @state = state
        @xml = ERB.new(
          File.read("#{Rails.root}/spec/fixtures/pivotal/story_update.xml.erb")
        ).result(binding)

        @event = PivotalEvent::Base.create_from_xml(@xml)
      end
    end
  end
end
