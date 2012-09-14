class JobRequest < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user 
  belongs_to :project
  belongs_to :draft
  # these will be 2 big awesome shite 
  # target job_request will be deduced (except those involving production and post production )
  def send_notification
    puts "this is the notification"
  end
  
  def JobRequest.create_event_based_job_request(job_request_source ,employee,project, draft, target  )
    case job_request_source
    when JOB_REQUEST_SOURCE[:shoot]
      project.project_members_with_project_role([:crew, :main_crew]).each do |x|
        job_request = JobRequest.new 
        job_request.project_id = project.id 
        job_request.user_id = x.id 
        job_request.start_date = project.shoot_start_date 
        job_request.deadline_date = project.shoot_end_date 
        job_request.creator_id = employee.id 
        job_request.job_request_source  = JOB_REQUEST_SOURCE[:shoot] 
        job_request.save
        job_request.send_notification
      end
    when JOB_REQUEST_SOURCE[:concept_planning] 
      project.project_members_with_project_role( [:main_crew] ).each do |x|
        job_request = JobRequest.new 
        job_request.project_id = project.id 
        job_request.user_id = x.id 
        job_request.start_date = Time.now.to_date 
        job_request.deadline_date = project.shoot_start_date 
        job_request.creator_id = employee.id 
        job_request.job_request_source  = JOB_REQUEST_SOURCE[:concept_planning] 
        job_request.save 
        job_request.send_notification
      end
    when JOB_REQUEST_SOURCE[:start_production]
      project.project_members_with_project_role( [:account_executive] ).each do |x|
        job_request = JobRequest.new 
        job_request.project_id = project.id 
        job_request.user_id = x.id 
        job_request.start_date = Time.now.to_date 
        job_request.deadline_date = Time.now.to_date + NUMBER_OF_DAYS_TO_START_PRODUCTION.days
        job_request.creator_id = employee.id 
        job_request.job_request_source  = JOB_REQUEST_SOURCE[:start_production] 
        job_request.save 
        job_request.send_notification
      end
    when JOB_REQUEST_SOURCE[:production_scheduling] 
      project.project_members_with_project_role( [:project_manager] ).each do |x|
        job_request = JobRequest.new 
        job_request.project_id = project.id 
        job_request.user_id = x.id 
        job_request.start_date = Time.now.to_date 
        job_request.deadline_date = Time.now.to_date + NUMBER_OF_DAYS_TO_START_PRODUCTION_SCHEDULING.days
        job_request.creator_id = employee.id 
        job_request.job_request_source  = JOB_REQUEST_SOURCE[:production_scheduling] 
        job_request.save 
        job_request.send_notification
      end
    else
      return  nil 
    end
  end
  
  

=begin
  JOB REQUEST SOURCE indicates where the job request came from (which state/phase)
  employee indicates who created or triggered the job request 
  project indicates the project where job request is gonna be created at 
  deliverable component => each project has several deliverables. each deliverable has several deliverable components
          Production is done by deliverable component  -> Deliverable Component is extracted from the draft object
          passed to the class method 
=end
  def JobRequest.finish_associated_job_request(job_request_source, employee, project,   draft ,  target   )
    # on FINISHING THESE job_request, what should happen? 
    case job_request_source
    when JOB_REQUEST_SOURCE[:project_membership_assignment_finalized]
      # in the little collins case, no job request starts the project creation
      # in nomina case, the project creation will be started by headpm receiving job request from 
      # marketing 
      # finalize the job request 
      
      # send job_request to main crew to create concept 
      # send job_request to main_crew and crew (assisting main_crew) to prepare for shooting date
      # project.create_on_project_member_assignment_finalization_job_requests(employee)
      JobRequest.create_event_based_job_request(JOB_REQUEST_SOURCE[:shoot] ,employee,project, draft, target  )
      JobRequest.create_event_based_job_request(JOB_REQUEST_SOURCE[:concept_planning] ,employee,project, draft, target  )
      
      # Send Email to the team member notifying their project membership  and their role 
      # project.create_project_member_assignment_notification 
    when JOB_REQUEST_SOURCE[:concept_planning]
      # on finish, notify the project manager that concept planning is finished 
      # notify the crew that the concept planning is finished, and reminder about the shoot date 
      
    when JOB_REQUEST_SOURCE[:shoot]
      # notify the PM that the shoot has been done + the result 
      # notify the associated AE that she can start calling client, or creating draft request for each deliverable component 
      JobRequest.create_event_based_job_request(JOB_REQUEST_SOURCE[:start_production] ,employee,project, draft, target  )
    when JOB_REQUEST_SOURCE[:start_production] # AE creates Draft for each deliverable component 
      # notify PM about the draft request , so that PM can start assigning production task 
      JobRequest.create_event_based_job_request(JOB_REQUEST_SOURCE[:production_scheduling] ,employee,project, draft, target  )
    when JOB_REQUEST_SOURCE[:production_scheduling] # PM create tasks to the team member 
      # notify the assigned team member that there is task. 
      
    when JOB_REQUEST_SOURCE[:production_execution] # assigned production team confirmed that she has finished the shite
      # NOTIFY QC that it is done , approval is required 
      
    when JOB_REQUEST_SOURCE[:qc_approval]  # QC approves the draft, ready to be sent to client 
      # NOTIFY associated AE that she can start calling the client for draft review 
       
    when JOB_REQUEST_SOURCE[:client_start_draft_review] # in order to submit client start draft review, AE has to have the estimated review finish date
      # create another job request for the associated AE to create reminder  based on the estimated review finish date 
    when JOB_REQUEST_SOURCE[:follow_up_client_draft_review] # retrieve the draft review from client + feedback 
      # over here, decide -> create another draft, or finalize draft 
      # if it is finalized, notify PM that the deliverable component is done , ready to assign post production 
      # if it is another draft creation, create job request for AE to create draft request 
      
    when JOB_REQUEST_SOURCE[:component_post_production_scheduling] # PM creates the jbo request for PP.. on creation, 
      # Notify post production about the deliverable item component printing 
      
    when JOB_REQUEST_SOURCE[:component_post_production_execution] # PP creates purchase order for supplier + ESTIMATED FINISH DATE
      # notification to associated PM and  AE  that it is in progress.
      # create the job request to himself, to do follow up 
      
    when JOB_REQUEST_SOURCE[:component_post_production_follow_up] # PP received the deliverable item from supplier
      # NOTIFY PM and AE that such deliverable has been retrieved. Can be delivered by AE to client 
      
    when JOB_REQUEST_SOURCE[:post_production_delivery] # AE deliver the deliverable to client
      # notify PM that deliverable component has been delivered  -> End of deliverable component creation 
    else
      return  nil 
    end
  end
end
