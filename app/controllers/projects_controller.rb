class ProjectsController < ApplicationController
  def index 
    @new_project = Project.new 
    @projects = Project.active_projects
    
    add_breadcrumb "Project Management", 'projects_url'
  end
  
   
  def create 
    @new_object =  Project.create_object( current_user, params[:project])  
  end
  
  def show
    @project = Project.find_by_id(params[:id])
    @deliverable_items = @project.active_deliverable_items 
    
    setup_project_role
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_url' + "(#{@project.id})", 
          "Project Management"
    
  end
  
  def update
    @project = Project.find_by_id params[:id]
    @project.update_with_attributes( current_user , params[:project] )
    @has_no_errors  = @project.errors.messages.length == 0 
    puts "The value of has no errors: #{@has_no_errors}"
    if @project.errors.messages.length != 0 
      puts "The project contains many errors\n"*5
      puts "The errors: "
      puts "The length : #{@project.errors.messages.length}"
      @project.errors.messages.each do |key, value|
        puts "#{value}"
      end
    else
      puts "The project doesn't have any errors\n"*5
    end
  end
  
  def finalize_membership_assignment
    @project = Project.find_by_id params[:entity_id]
    
    @project.finalize_project_membership_assignment(current_user)
  end
  
  
=begin
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:concept_planning]
=end

  def project_based_concept_planning_fulfillment
    @project = Project.find_by_id params[:project_id] 
    
    add_breadcrumb "Project Management", 'projects_url'  
    set_breadcrumb_for @project, 'concept_planning_fulfillment_url' + "(#{@project.id})", 
          "Concept Planning"
          
    # render :file => "projects/job_requests/concept_planning/concept_planning_fulfillment"
  end
  
  def concept_planning_fulfillment
    @project = Project.find_by_id params[:project_id]  
    
    add_breadcrumb "Task Management", 'job_requests_url'  
    set_breadcrumb_for @project, 'concept_planning_fulfillment_url' + "(#{@project.id})", 
          "Concept Planning"
          
    render :file => "projects/job_requests/concept_planning/concept_planning_fulfillment"
  end
  
  def update_project_concept
    @project = Project.find_by_id params[:project_id]
    @project.update_project_concept(current_user, params[:project][:concept])
    @project.reload 
    @object = @project 
     
  
    render :file => "projects/job_requests/concept_planning/update_project_concept"
  end
  
  def finalize_concept
    @project = Project.find_by_id params[:entity_id] 
    @project.finalize_concept(current_user)
    
    render :file => "projects/job_requests/concept_planning/finalize_concept" 
  end
  
  
  
=begin
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:shoot]
=end

  def project_based_shoot_finalization
    @project = Project.find_by_id params[:project_id] 

    add_breadcrumb "Project Management", 'projects_url'  
    set_breadcrumb_for @project, 'project_based_shoot_finalization_url' + "(#{@project.id})", 
          "Shoot Data Planning"

    # render :file => "projects/job_requests/concept_planning/concept_planning_fulfillment"
  end

  def shoot_finalization
    @project = Project.find_by_id params[:project_id]  

    add_breadcrumb "Task Management", 'job_requests_url'  
    set_breadcrumb_for @project, 'shoot_finalization_url' + "(#{@project.id})", 
          "Shoot Finalization"

    render :file => "projects/job_requests/shoot/shoot_finalization"
  end

  def update_shoot_data
    @project = Project.find_by_id params[:project_id]
    @project.update_project_shoot_data(current_user, params[:project][:shoot_data])
    @project.reload 
    @object = @project 
 


    render :file => "projects/job_requests/shoot/update_shoot_data"
  end
  
  def finalize_shoot_data
    @project = Project.find_by_id params[:entity_id] 
    @project.finalize_shoot_data(current_user)
    
    render :file => "projects/job_requests/shoot/finalize_shoot_data" 
  end
  
  protected 
  
  def setup_project_role
    @main_crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:main_crew]
    @crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:crew]
    @pm_project_role = ProjectRole.find_by_name PROJECT_ROLE[:project_manager]
    @ae_project_role = ProjectRole.find_by_name PROJECT_ROLE[:account_executive] 
    @qc_project_role = ProjectRole.find_by_name PROJECT_ROLE[:quality_control]
  end
  
  
end
