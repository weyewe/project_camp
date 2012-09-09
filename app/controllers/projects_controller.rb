class ProjectsController < ApplicationController
  def index 
    @new_project = Project.new 
    @projects = Project.active_deliverable_subcriptions
    
    add_breadcrumb "Project Management", 'projects_url'
  end
  
   
  def create 
    @new_object =  Project.create_object( current_user, params[:project])  
  end
  
  def show
    @project = Project.find_by_id params[:id]
    add_breadcrumb "Project Management", 'projects_url'
    set_breadcrumb_for @project, 'project_url' + "(#{@project.id})", 
          "Project Management for #{@project.title}"
    
  end
end
