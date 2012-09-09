class DeliverableSubcription < ActiveRecord::Base
  attr_accessible :package_id, :deliverable_id
  belongs_to :package
  belongs_to :deliverable
  
  validates_presence_of :package_id , :deliverable_id 
  
  def self.create_child_object(employee, parent_object, object_params)
    object_params[:package_id] = parent_object.id 
    new_object = self.new object_params  
    if not employee.has_role?(:admin)
      return new_object 
    end
    
    new_object.save 
    return new_object
  end
  
  
end
