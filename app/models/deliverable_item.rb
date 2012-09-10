class DeliverableItem < ActiveRecord::Base
  attr_accessible :deliverable_id, :sub_item_quantity, :project_specific_description, :project_id 
  belongs_to :project 
  belongs_to :deliverable
  
  def self.create_child_object(employee, parent_object, object_params)
    object_params[:project_id] = parent_object.id 
    new_object = self.new object_params  
    if not employee.has_role?(:admin)
      return new_object 
    end
    new_object.is_basic_deliverable = false 
    
    if new_object.sub_item_quantity.nil?  
      # get the data from deliverable item 
      new_object.sub_item_quantity = Deliverable.find_by_id( object_params[:deliverable_id]).sub_item_quantity
    end
    
    new_object.save 
    return new_object
  end
  
  
end
