require 'spec_helper'

describe Dashboard::Entry do
  describe "db conifg" do
    it "shouldn't hit the same db as ActiveRecord::Base" do
      Dashboard::Entry.connection.should_not == ActiveRecord::Base.connection
    end
    it "should have access to its table" do
      lambda { Dashboard::Entry.count }.should_not raise_error
    end
  end
end
