class DeliverablesController < ApplicationController
  def index 
    @new_deliverable = Deliverable.new 
    @deliverables = Deliverable.order("created_at DESC")
    
    add_breadcrumb "Deliverable Management", 'deliverables_url'
  end
  
   
  def create 
    @new_object =  Deliverable.create_object( current_user, params[:deliverable])  
  end
end
