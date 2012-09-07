class PackagesController < ApplicationController
  
  def index 
    @new_package = Package.new 
    @packages = Package.order("created_at DESC")
    
    add_breadcrumb "Package Management", 'packages_url'
  end
  
   
  def create 
    @new_object =  Package.create_object( current_user, params[:package])  
  end
end
