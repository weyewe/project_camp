class DraftsController < ApplicationController
  def index
    @deliverable_component_subcription = DeliverableComponentSubcription.find_by_id params[:deliverable_component_subcription]
    @deliverable_item = @deliverable_component_subcription.deliverable_item
    @project = @deliverable_item.project 
    
  end
end
