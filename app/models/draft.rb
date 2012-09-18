class Draft < ActiveRecord::Base
  attr_accessible :overall_feedback 
  belongs_to :project
  belongs_to :deliverable_component_subcription
  
  validates_presence_of :overall_feedback
  
  has_many :job_requests 
  
  
  def self.create_child_object(employee, parent_object, object_params)
    project = parent_object.project 
    # if employee doesn't have project role: Project Manager or AE  
    new_object = self.new object_params  
    ae_project_role = ProjectRole.find_by_name PROJECT_ROLE[:account_executive]
    if not employee.has_project_role?( project, ae_project_role)
      return new_object 
    end
    
     
    
    if parent_object.drafts.where(:is_finished => false).count != 0 
      new_object.errors.add(:overall_feedback , "There is unfinished draft!" )
      return new_object 
    end
    
    new_object.project_id = project.id 
    new_object.deliverable_component_subcription_id = parent_object.id 
    new_object.number = parent_object.drafts.count + 1 
    
    new_object.save 
    if new_object.persisted?
      JobRequest.create_event_based_job_request( JOB_REQUEST_SOURCE[:production_scheduling] ,employee,project, new_object, nil   )
    end
    # send the email to PM over here 
    
    return new_object
  end
end
