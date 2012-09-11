class DeliverableComponentSubcription < ActiveRecord::Base
  attr_accessible :deliverable_item_id, :deliverable_component_id
  belongs_to :deliverable_item
  belongs_to :deliverable_component
  
  has_many :drafts 
  
  
end
