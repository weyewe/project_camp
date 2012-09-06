class ProjectsController < ApplicationController
  def index
    @total_active_projects = Project.count 
    @new_project = Project.new
    
    add_breadcrumb "Active Projects", 'projects_url' 
  end
  
  
  def create
    @new_project = Project.create_by_user( current_user, params[:project] )
    
    if @new_project.errors.messages.length == 0 
      
    else
      flash[:error] = "Check your data!"
      render :file => 'projects/index'
    end
  end
end
