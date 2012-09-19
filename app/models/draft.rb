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
  
  def assigned_production_members
    User.joins(:job_requests).where(:job_requests => {:draft_id => self.id , 
          :job_request_source => JOB_REQUEST_SOURCE[:production_execution],
          :is_canceled => false })
  end
  
  def production_job_requests 
    self.job_requests.where(:job_request_source => JOB_REQUEST_SOURCE[:production_execution],
    :is_canceled => false ).order("created_at DESC")
  end
  
=begin
  Create production assignment
=end

  def create_production_assignment(employee, object_params)
    new_object = JobRequest.new  
    
    new_object.draft_id = self.id
    new_object.project_id = self.deliverable_component_subcription.project_id 
    new_object.creator_id = employee.id 
    
    new_object.description = object_params[:description]
    if  User.find_by_id( object_params[:user_id] ).nil?
      new_object.errors.add(:user_id , "The Employee is Invalid. Select an employee to do production " )
      return new_object
    else
      new_object.user_id = object_params[:user_id]
    end
    
    
    start_date = Draft.parse_date( object_params[:start_date])
    deadline_date = Draft.parse_date( object_params[:deadline_date]) 
    if start_date.nil?
      new_object.errors.add(:start_date , "Please enter a valid date. Format: dd/mm/yyyy" )
      return new_object 
    end
    
    if deadline_date.nil?
      new_object.errors.add(:start_date , "Please enter a valid date. Format: dd/mm/yyyy" )
      return new_object 
    end
    
    if start_date > deadline_date
      new_object.errors.add(:start_date , "Start Date must not be later than deadline date" )
      return new_object
    end
    
    
    new_object.start_date = start_date 
    new_object.deadline_date = deadline_date
    new_object.job_request_source = JOB_REQUEST_SOURCE[:production_execution] 
    new_object.save 
    
    # if not self.deadline_date.nil?
    #     if new_object.deadline_date > self.deadline_date 
    #       self.deadline_date = new_object.deadline_date
    #       self.save
    #     end
    #   else
    #     self.deadline_date = new_object.deadline_date
    #     self.save
    #   end
    
    new_object.send_notification
    
    return new_object 
    
  end
  
  
  def self.parse_date( date_string ) 
    if date_string.nil? or date_string.length == 0 
      return nil
    end
    
    date_array = date_string.split("/")
    begin
      Date.new(date_array[2].to_i, date_array[1].to_i, date_array[0].to_i) 
    rescue 
      return nil 
    end
  end
  
  
  
end
