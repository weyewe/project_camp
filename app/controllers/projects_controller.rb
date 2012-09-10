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
end
