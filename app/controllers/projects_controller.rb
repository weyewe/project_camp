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
  JOB REQUEST FULFILLMENT 
=end
  def concept_planning_fulfillment
    @job_request = JobRequest.find_by_id params[:job_request_id]
    @project = @job_request.project 
    
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
    
    if (not @object.errors.any? ) and  
          (not @object.concept.nil?)  and  
          (@object.concept.length !=  0  )
        
      puts "THIS IS NOT ERROR moron\n"*5
      if @object.errors.messages.count != 0
        puts "error count is not equal 0"
      end
      
      if  @object.concept.nil? 
        puts "the object.concept is nil"
      end
      
      if  @object.concept.length == 0  
        puts "the object.concept.length is 0 "
      end
      
    else
      puts "THIS is error"
    end
      
  
    render :file => "projects/job_requests/concept_planning/update_project_concept"
  end
  
  def setup_project_role
    @main_crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:main_crew]
    @crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:crew]
    @pm_project_role = ProjectRole.find_by_name PROJECT_ROLE[:project_manager]
    @ae_project_role = ProjectRole.find_by_name PROJECT_ROLE[:account_executive] 
    @qc_project_role = ProjectRole.find_by_name PROJECT_ROLE[:quality_control]
  end
  
  
end
