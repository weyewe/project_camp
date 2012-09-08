class DeliverableSubcriptionsController < ApplicationController
  def index
    @package = Package.find_by_id params[:package_id]
    @new_deliverable_subcription = DeliverableSubcription.new 
    @deliverable_subcriptions = @deliverable.active_deliverable_components
    
    add_breadcrumb "Deliverable Management", 'deliverables_url'
    set_breadcrumb_for @deliverable, 'deliverable_deliverable_components_url' + "(#{@deliverable.id})", 
          "Component Management for #{@deliverable.name}" 
  end
  
  def create
    @deliverable = Deliverable.find_by_id params[:deliverable_id]
    @parent_object = @deliverable 
    @new_object =  DeliverableComponent.create_child_object( current_user, @deliverable, params[:deliverable_component]) 
  end
end
