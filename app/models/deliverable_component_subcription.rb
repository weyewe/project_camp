class DeliverableComponentSubcription < ActiveRecord::Base
  attr_accessible :deliverable_item_id, :deliverable_component_id, :project_id
  belongs_to :deliverable_item
  belongs_to :deliverable_component
  belongs_to :project
  
  has_many :drafts 
  
  def last_draft
    if self.drafts.count == 0
      return nil
    end
    
    self.drafts.where(:is_finished => false ).order("created_at DESC").first 
  end
  
  
  
end
