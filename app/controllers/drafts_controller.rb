class DraftsController < ApplicationController
  def index
    @deliverable_component_subcription = 
      DeliverableComponentSubcription.find_by_id params[:deliverable_component_subcription_id]
    @project = @deliverable_component_subcription.project
    
    @deliverable_item = @deliverable_component_subcription.deliverable_item
    @deliverable_component = @deliverable_component_subcription.deliverable_component
    @drafts = @deliverable_component_subcription.drafts.order("created_at ASC") 
     
    
    @new_draft = Draft.new 
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_deliverable_items_production_overview_url' + "(#{@project.id})", 
          "Production Management" 
    set_breadcrumb_for @deliverable_component_subcription, 'deliverable_component_subcription_drafts_url' + "(#{@deliverable_component_subcription.id})", 
          "Component: #{@deliverable_component.name}" 
  end
  
  def create
    @deliverable_component_subcription = 
      DeliverableComponentSubcription.find_by_id params[:deliverable_component_subcription_id]
    @parent_object = @deliverable_component_subcription 
    @new_object =  Draft.create_child_object( current_user, @deliverable_component_subcription, params[:draft]) 
  end
end
