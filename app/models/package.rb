class Package < ActiveRecord::Base
  attr_accessible :title, :description
  
  has_many :projects
  has_many :deliverables, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  
  validates_presence_of :title 
  
  def self.create_object( employee, object_params  ) 
    new_object = self.new object_params 
    if not employee.has_role?(:admin)
      return new_object 
    end
    
    new_object.save 
    return new_object  
  end
  
  def active_deliverable_subcriptions
    self.deliverable_subcriptions.where(:is_active => true )
  end
end
