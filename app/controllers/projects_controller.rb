class ProjectsController < ApplicationController
  def index
    @total_active_projects = Project.count 
    @new_project = Project.new
    
    add_breadcrumb "Active Projects", 'projects_url' 
  end
end
