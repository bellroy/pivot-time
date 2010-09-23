require 'spec_helper'

describe Project do
  describe "slimtimer task names" do
    it "should use the default slimtimer task prefix" do
      p = Project.new('pants', { 'default_slimtimer_prefix' => 't:pants website' })
      p.slimtimer_task_prefix.should == 't:pants website'
    end

    describe "for a project with tag-specific prefixes" do
      before(:each) do
        @project = Project.new('pants', {
                     'default_slimtimer_prefix' => 't:pants website',
                     'tagged_slimtimer_prefixes' => {
                       'awesome' => 't:pants w00t'
                     }})
      end

      it "should use a tag-specific task prefix" do
        @project.slimtimer_task_prefix(['awesome']).should == 't:pants w00t'
      end

      it "should fallback to default task prefix when there's no matching tag" do
        @project.slimtimer_task_prefix(['crappy']).should == 't:pants website'
      end
    end
  end
end
