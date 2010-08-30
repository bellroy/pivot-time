require 'spec_helper'

describe PivotalEventsController do

  describe "responding to a Pivotal Tracker web-hook" do

    it "creates a Pivotal Event using the posted XML" do
      PivotalEvent::Base.should_receive(:create_from_xml)
      post :create
    end

  end

end
