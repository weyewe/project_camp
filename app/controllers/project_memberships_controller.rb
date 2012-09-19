class ProjectMembershipsController < ApplicationController
  def index  
    @new_project_membership = ProjectMembership.new 
    @project = Project.find_by_id params[:project_id]
    
    @project_memberships = @project.project_memberships 
    # PROJECT_ROLE = {
    #   :main_crew => "MainCrew", # main photographer
    #   :crew => "Crew",  # assistant 
    # 
    #   :project_manager => "ProjectManager", # the one in charge to assign task to production team 
    #   # assign task to post production team 
    #   # 
    #   :account_executive => "AccountExecutive",  # the one talking to client 
    #   :production => "Production" , 
    #   :post_production => "PostProduction", # the one chasing the printing 
    #   :quality_control => "QualityControl" # the one giving internal approval before AE pass the draft to client 
    # }
    setup_project_role
    
    
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_project_memberships_url' + "(#{@project.id})", 
          "Membership Management"
  end
  
  
  def assign_project_membership_role_for
    @project = Project.find_by_id params[:project_id]
    @decision = params[:membership_decision].to_i
    @project_role   = ProjectRole.find_by_id params[:membership_provider]
    @employee = User.find_by_id params[:membership_consumer]
  
    setup_project_role
    
    if @decision == TRUE_CHECK
      @project.add_project_membership( current_user, @employee,  @project_role)
    elsif @decision == FALSE_CHECK
      @project.remove_project_membership(current_user,  @employee,  @project_role  )
    end 
  end
  
  def task_based_project_membership_assignment
    @new_project_membership = ProjectMembership.new 
    @project = Project.find_by_id params[:project_id]
    @job_request = JobRequest.find_by_id params[:job_request_id]
    
    @project_memberships = @project.project_memberships
    
    setup_project_role
    
    
    add_breadcrumb "Task Management", 'job_requests_url'
    set_breadcrumb_for @project, 'task_based_project_membership_assignment_url' + "(#{@job_request.id},  #{@project.id})", 
          "Membership Management"
  end
  
  def setup_project_role
    @main_crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:main_crew]
    @crew_project_role = ProjectRole.find_by_name PROJECT_ROLE[:crew]
    @pm_project_role = ProjectRole.find_by_name PROJECT_ROLE[:project_manager]
    @ae_project_role = ProjectRole.find_by_name PROJECT_ROLE[:account_executive] 
    @qc_project_role = ProjectRole.find_by_name PROJECT_ROLE[:quality_control]
  end
end
