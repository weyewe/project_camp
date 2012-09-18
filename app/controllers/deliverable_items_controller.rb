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
  
=begin
  PRODUCTION PROGRESS 
=end
  def project_deliverable_items_production_overview
    @project = Project.find_by_id params[:project_id]
    @deliverable_items = @project.deliverable_items.order("created_at DESC")
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_deliverable_items_production_overview_url' + "(#{@project.id})", 
          "Production Management"
  end
  
  
  def task_based_deliverable_items_progress
    @project = Project.find_by_id params[:project_id]
    @deliverable_items = @project.deliverable_items.order("created_at DESC")
    
    add_breadcrumb "Task Management", 'job_requests_url'
    set_breadcrumb_for @project, 'task_based_deliverable_items_progress_url' + "(#{@project.id})", 
          "Production Management"
  end
  
end
