class DeliverableComponent < ActiveRecord::Base
  attr_accessible :name  , :description
  belongs_to :deliverable 
  
  validates_presence_of :name 
  
  has_many :deliverable_items, :through => :deliverable_component_subcriptions
  has_many :deliverable_component_subcriptions 
  
  def self.create_child_object(employee, parent_object, object_params)
    new_object = self.new object_params 
    new_object.deliverable_id = parent_object.id 
    
    if not employee.has_role?(:admin)
      return new_object 
    end
    
    new_object.save 
    return new_object
  end
  
  
end
