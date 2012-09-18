class DraftsController < ApplicationController
  def index
    setup_index
    
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
  
  
  def task_based_draft_creation_for_component
    setup_index
    
    add_breadcrumb "Task Management", 'job_requests_url'
    set_breadcrumb_for @project, 'task_based_deliverable_items_progress_url' + "(#{@project.id})", 
          "Production Management"
    set_breadcrumb_for @deliverable_component_subcription, 'task_based_draft_creation_for_component_url' + "(#{@deliverable_component_subcription.id})", 
          "Component: #{@deliverable_component.name}"
  end
  
  
  def task_based_production_team_assignment
    @job_request = JobRequest.find_by_id params[:job_request_id]
    @project = @job_request.project 
    @draft = @job_request.draft 
    
    @production_job_requests = @draft.job_requests.where(:job_request_source => JOB_REQUEST_SOURCE[:production_execution]).order("created_at DESC")
    
    add_breadcrumb "Task Management", 'job_requests_url'
    set_breadcrumb_for @project, 'task_based_production_team_assignment_url' + "(#{@job_request.id}, #{@project.id})", 
          "Production Management: Task Assignment"
          
    render :file => "drafts/production_assignment/task_based_production_team_assignment"
  end
  
  protected
  def setup_index
    @deliverable_component_subcription = 
      DeliverableComponentSubcription.find_by_id params[:deliverable_component_subcription_id]
    @project = @deliverable_component_subcription.project
    
    @deliverable_item = @deliverable_component_subcription.deliverable_item
    @deliverable_component = @deliverable_component_subcription.deliverable_component
    @drafts = @deliverable_component_subcription.drafts.order("created_at ASC") 
     
    
    @new_draft = Draft.new
  end
end
