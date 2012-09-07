class Deliverable < ActiveRecord::Base
  attr_accessible :name, :description,
                  :has_sub_item,
                  :sub_item_quantity,
                  :sub_item_name 
                  
  validates_presence_of :name 
  has_many :deliverable_components 
  
  def self.create_object( employee, object_params  ) 
    new_object = self.new object_params 
    if not employee.has_role?(:admin)
      return new_object 
    end
    
    if new_object.has_sub_item == true 
      if new_object.sub_item_quantity.nil? or new_object.sub_item_name.nil?
        new_object.errors.add(:sub_item_quantity , "Must be present since the 'has sub item' is checked!" ) 
        new_object.errors.add(:sub_item_name , "Must be present since the 'has sub item' is checked" )  
        return new_object 
      end
    else
      new_object.sub_item_quantity = nil
      new_object.sub_item_name = nil 
    end
    
    new_object.save 
    return new_object  
  end
  
  
  def active_deliverable_components
    self.deliverable_components.where(:is_deleted => false).order("created_at DESC")
  end
  
end
