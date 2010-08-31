require 'spec_helper'

describe PivotalEvent::StoryUpdate do
  describe "handling XML posts" do
    describe "a pivotal event and its story," do
      before do
        @time = "2010/06/27 22:09:44 UTC"
        @desc = %(Peter Hollows added "make it work on Webkit")
        @state = "finished"
        @xml = ERB.new(
          File.read("#{Rails.root}/spec/fixtures/pivotal/story_update.xml.erb")
        ).result(binding)

        @event = PivotalEvent::Base.create_from_xml(@xml)
      end

      %w(start finish restart reject accept deliver).each do |state|
        describe "to #{state} a story" do
          it "marks the story as #{state}ed" do
            @event.story.state.should == @state
          end

          # TODO
#           it "records the right #{state}ed_at time" do
#             @event.story.send(:"#{state}ed_at").should == Time.parse(@time)
#           end
        end
      end
    end
  end
end
