class PivotalEventsController < ApplicationController
  def create
    PivotalEvent::Base.create_from_xml(request.body)
    head :ok
  end
end
