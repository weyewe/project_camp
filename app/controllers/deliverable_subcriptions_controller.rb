class DeliverableSubcriptionsController < ApplicationController
  def index
    @package = Package.find_by_id params[:package_id]
    @new_deliverable_subcription = DeliverableSubcription.new 
    @deliverable_subcriptions = @package.active_deliverable_subcriptions
    
    add_breadcrumb "Package Management", 'packages_url'
    set_breadcrumb_for @deliverable, 'package_deliverable_subcriptions_url' + "(#{@package.id})", 
          "Deliverable Assignment for #{@package.title}" 
  end
  
  def create
    @package = Package.find_by_id params[:package_id]
    @parent_object = @package 
    @new_object =  DeliverableSubcription.create_child_object( current_user, @package, params[:deliverable_subcription]) 
  end
end
