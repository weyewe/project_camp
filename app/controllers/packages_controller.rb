class PackagesController < ApplicationController
  
  def index 
    @new_package = Package.new 
    @packages = Package.order("created_at DESC")
    
    add_breadcrumb "Package Management", 'packages_url'
  end
  
  
  def new
    @new_package = Package.new 
    @office = current_office 
  end
  
  def create 
    @new_package =  Package.create_package( current_user, params[:package])
    
    if  @new_package.persisted?
      flash[:notice] = "The package '#{@new_package.name}' has been created." 
      redirect_to new_package_url 
      return 
    else
      flash[:error] = "Hey, do something better"
      
      render :file => "packages/new"
    end
  end
end
