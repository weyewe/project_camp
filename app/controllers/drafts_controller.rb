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
  
=begin
  Production TEAM Assignment 
=end
  
  def production_team_assignment
    setup_production_team_assignment
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_deliverable_items_production_overview_url' + "(#{@project.id})", 
          "Production Management" 
    set_breadcrumb_for @deliverable_component_subcription, 'deliverable_component_subcription_drafts_url' + "(#{@deliverable_component_subcription.id})", 
          "Component: #{@deliverable_component.name}"
    set_breadcrumb_for @draft, 'production_team_assignment_url' + "(#{@draft.id})", 
          "Production Assignment"
          
    render :file => "drafts/production_assignment/production_team_assignment"
  end
  
  def execute_production_team_assignment
    @draft = Draft.find_by_id params[:draft_id]
    @new_object = @draft.create_production_assignment( current_user, params[:job_request]  )
    
    render :file =>"drafts/production_assignment/execute_production_team_assignment" 
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
  
  def finalize_production_team_assignment
    @draft = Draft.find_by_id params[:entity_id]
    @draft.finalize_production_team_assignment(current_user) 
    
    render :file => "drafts/production_assignment/finalize_production_team_assignment"
  end
  
=begin
  INTERNAL QC DEADLINE 
=end
  def internal_qc_deadline_assignment
    setup_internal_qc_deadline_assignment 
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_deliverable_items_production_overview_url' + "(#{@project.id})", 
          "Production Management" 
    set_breadcrumb_for @deliverable_component_subcription, 'deliverable_component_subcription_drafts_url' + "(#{@deliverable_component_subcription.id})", 
          "Component: #{@deliverable_component.name}"
    set_breadcrumb_for @draft, 'internal_qc_deadline_assignment_url' + "(#{@draft.id})", 
          "QC Deadline Assignment"
          
    render :file => "drafts/qc_deadline/internal_qc_deadline_assignment"
    
    
  end
  
  
  
  def execute_internal_qc_deadline_assignment
    @draft = Draft.find_by_id params[:draft_id]
    @draft.update_internal_qc_deadline(current_user, params[:draft] )
    @draft.reload 
    @object = @draft
    
    render :file =>"drafts/qc_deadline/execute_internal_qc_deadline_assignment" 
  end
=begin
  PROTECTED ZONE 
=end
  
  protected
  
  def setup_internal_qc_deadline_assignment
    @draft = Draft.find_by_id params[:draft_id]
    @deliverable_component_subcription = @draft.deliverable_component_subcription
    @deliverable_component = @deliverable_component_subcription.deliverable_component 
    @project = @deliverable_component_subcription.project
  end
  
  def setup_production_team_assignment
    @draft = Draft.find_by_id params[:draft_id]
    @deliverable_component_subcription = @draft.deliverable_component_subcription
    @deliverable_component = @deliverable_component_subcription.deliverable_component 
    @project = @deliverable_component_subcription.project
    @job_requests = @draft.production_job_requests 
    @new_object = JobRequest.new 
  end
  
  
  def setup_index
    @deliverable_component_subcription = 
      DeliverableComponentSubcription.find_by_id params[:deliverable_component_subcription_id]
    @project = @deliverable_component_subcription.project
    
    @deliverable_item = @deliverable_component_subcription.deliverable_item
    @deliverable_component = @deliverable_component_subcription.deliverable_component
    @drafts = @deliverable_component_subcription.drafts.order("created_at ASC") 
    @last_draft = @deliverable_component_subcription.last_draft 
    
    @new_draft = Draft.new
  end
end
