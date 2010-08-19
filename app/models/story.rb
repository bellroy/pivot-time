class Story < ActiveRecord::Base
  has_many :pivotal_events, :class_name => 'PivotalEvent::Base', :dependent => :destroy
end
