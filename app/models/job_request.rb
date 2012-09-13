class JobRequest < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user 
  belongs_to :project
  belongs_to :draft
  # these will be 2 big awesome shite 
  # target job_request will be deduced (except those involving production and post production )
  
  def JobRequest.create_event_based_job_request(job_request_source ,creator,project, draft, target  )
    case job_request_source
    when JOB_REQUEST_SOURCE[:shoot]
      # close one, and open another 
    else
      return  nil 
    end
  end
  
  
  
  def JobRequest.finish_associated_job_request(job_request_source, creator, project, draft , target   )
    # on FINISHING THESE job_request, what should happen? 
    case job_request_source
    when JOB_REQUEST_SOURCE[:project_membership_assignment_finalized]
      # Send Email to the team member notifying their project membership  and their role 
      # send job_request to main crew to create concept 
      # send job_request to main_crew and crew (assisting main_crew) to prepare for shooting date 
    when JOB_REQUEST_SOURCE[:concept_planning]
      # on finish, notify the project manager that concept planning is finished 
      # notify the crew that the concept planning is finished, and reminder about the shoot date 
      
      # close one, and open another
    when JOB_REQUEST_SOURCE[:shoot]
      # notify the PM that the shoot has been done + the result 
      # notify the associated AE that she can start calling client, or creating draft request for each deliverable component 
      
    when JOB_REQUEST_SOURCE[:start_production] # AE creates Draft for each deliverable component 
      # notify PM about the draft request , so that PM can start assigning production task 
      
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
