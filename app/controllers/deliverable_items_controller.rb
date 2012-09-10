class DeliverableItemsController < ApplicationController
  def index 
    @project = Project.find_by_id params[:project_id]
    @new_deliverable_item  = DeliverableItem.new 
    @deliverable_items = @project.active_deliverable_items
     
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_deliverable_items_url' + "(#{@project.id})", 
          "Deliverable Management"
  end
  
   
  def create 
    @project = Project.find_by_id params[:project_id]
    @parent_object = @project
    @new_object =  DeliverableItem.create_child_object( current_user, @project, params[:deliverable_item])  
  end
  
  def destroy
  end
  
end
