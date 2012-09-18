COMPANY_NAME = "magnifique360"
COMPANY_TITLE = "magnifique360"
=begin
  MODEL CONSTANT
=end
JAKARTA_HOUR_OFFSET = 7 
# in the whole application 
USER_ROLE = { 
  :admin => "Admin",
  
  :head_project_manager => "HeadProjectManager", # can create projects  
  :employee => "Employee", 
  # :crew => "Crew",
  # 
  # :project_manager => "ProjectManager",
  # :account_executive => "AccountExecutive" , 
  # # Back office roles .. there can be designer editor 
  # :production => "Production",
  # :post_production => "PostProduction" 
  
}

PROJECT_ROLE = {
  :head_project_manager => "HeadProjectManager",
  :main_crew => "MainCrew", # main photographer
  :crew => "Crew",  # assistant 
  
  :project_manager => "ProjectManager", # the one in charge to assign task to production team 
  # assign task to post production team 
  # 
  :account_executive => "AccountExecutive",  # the one talking to client 
  :production => "Production" , # in charge to create design + edit .. Assumption: no context switching
  # but, case: if she finishes early that schedule, what should she do if there are no projects?
  #   assign another project? 
  # yeah, assign another project. But first, she has to be recorded as the participant in the given project
  # then, she will be assigned job request
  
  # definition designer and editor -> in the draft.. only relevant in the album creation..
  :post_production => "PostProduction", # the one chasing the printing 
  :quality_control => "QualityControl" # the one giving internal approval before AE pass the draft to client 
}



ARTICLE_PICTURE_TYPE = {
  :migrated_from_project => 1 ,
  :pure_article_upload => 2 
}

ARTICLE_TYPE = {
  :mapped_from_project => 1 , 
  :independent_article =>  2
}

PACKAGE_MEDIUM = {
  :photo => 0,
  :video => 1 
}

CONTACT_PURPOSE = {
  :product_enquiry  => 0, 
  :planned_follow_up => 1 , 
  :production_follow_up => 2  ,
  :after_sales_follow_up  => 3
} 


DEFAULT_TIMEZONE = "Jakarta"
DEFAULT_TIME_OFFSET = 7 

MIN_YDAY = 1
MAX_YDAY = 366


DEFAULT_IMPORTANT_EVENT_PERIOD = 60

# JOB REQUEST SPECIFIC 

PROJECT_ROLE_COLOR = {
  :main_crew => 'red',
  :crew => 'pink',
  :project_manager => 'purple',
  :account_executive => 'blue',
  :production => 'orange',
  :post_production => '',
  :quality_control => 'green',
  
  :head_project_manager => 'yellow'
}

JOB_REQUEST_ROLE_TEXT = {
  :main_crew => "Main Crew",
  :crew => 'Crew',
  :project_manager => 'PM',
  :account_executive => 'AE',
  :production => 'Prod',
  :post_production => 'PostProd',
  :quality_control => 'QC'
}

JOB_REQUEST_ROLE = {
  :assign_project_membership => :head_project_manager, 
  :concept_planning => :main_crew,
  :shoot => :main_crew, 
  :start_production => :account_executive, 
  :production_scheduling => :project_manager, 
  :production_execution => :production, 
  :qc_approval => :quality_control,
  :client_start_draft_review => :account_executive, 
  :follow_up_client_draft_review => :account_executive, 
  :component_post_production_scheduling => :project_manager , 
  :component_post_production_execution => :post_production , 
  :component_post_production_follow_up => :post_production , 
  :post_production_delivery => :account_executive  
}
#  THIS IS THE CORE OF THE APP
# locking the business process 
JOB_REQUEST_SOURCE = {
  :assign_project_membership =>0 , 
  # is created on Membership FINALIZATION  by Head PM 
  :concept_planning => 1 ,  # main crew will have this job request
  # on finish -> nothing happen  -> just notify the PM .. no further job_request created 
  
  :shoot => 5,  # main crew and crew  
  # on finish -> AE will be notified to start the production 
  
  :start_production => 10, # AE will have this task, to create draft 
  # on finish -> PM will be notified to give task to production team 
  
  # gonna be created after AE created the draft for a particular component 
  :production_scheduling => 20, # PM will have this job request, to assign job
  # on finish -> the selected production team will have task + deadline 
  
  # 
  :production_execution => 25, # production team will have this request -> either layout design or photo edit 
  # on finish -> QC will be notified, and requested for approval  
  
  :qc_approval => 35,  # QC will have this job request, before passing the draft to client 
  # on finish -> AE will be notified to pass the draft to the client 
  :client_start_draft_review => 40,  # AE will have this job, after QC approve the draft 
  # on finish -> AE will be notified to do follow up at the specified date 
  
  :follow_up_client_draft_review => 45,  # AE will have this job, auto generated after AE mark that draft has been passed
  # after client returned the draft review, there can be 2 options -> finish drafting for that component 
  #                                                                 -> start another draft  -> it will be back to production scheduling (20)
  
  # if it finishing the drafting -> production is done for that component, notify the PM to start allocating
  # post-production resources for that component's post production 
  :component_post_production_scheduling => 50, # PM will have this job. For a particular component, he has to give task to subordinate to start searching
    # on finish -> PP will be notified to find supplier and negotiate + create purchase order 
    
  :component_post_production_execution => 55, # Post Production will have this job.. search for the supplier, and create the fucking shit.
    # on finish => PP will be notified to do follow up at the estimated finish date 
    
  :component_post_production_follow_up => 60, # PP will have the job still. He needs to follow up so that we can have the shit together.
    # on finish => AE will be notified to do delivery to the client 
    
  :post_production_delivery => 65 # AE will have the job. Send the deliverables to the customer  
    # on finish => PM and Head PM will be notified that the particular Deliverable is sent 
}

=begin
  CONSTANT for AJAX
=end
TRUE_CHECK = 1
FALSE_CHECK = 0

PROPOSER_ROLE = 0 
APPROVER_ROLE = 1





=begin
  UTILITY ASSETs
=end
AVATAR_IMAGE = "https://s3.amazonaws.com/potoschool_icon/default_profile_pic.jpg"
TRANSLOADIT_UPLOAD_URL = "http://api2.transloadit.com/assemblies"
UPLOADIFY_SWF_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify.swf"
UPLOADIFY_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"
UPLOADIFIVE_CANCEL_URL = "http://s3.amazonaws.com/circle-static-assets/uploadify-cancel.png"
PRELOADER_URL = "http://s3.amazonaws.com/circle-static-assets/ajax-loader.gif"


=begin
  DISPLAY RELATED
=end
INDEPENDENT_ARTICLE_VALUE = 0 
ARTICLE_FROM_PROJECT_VALUE =  1 

FRONT_PAGE_WIDTH = 325
ARTICLE_WIDTH = 800

S3_BUCKET_BLOG_DEV  = 'nomina-dev'
S3_BUCKET_BLOG_PROD = 'nomina-prod'


SHOWLOADING_LOADER_URL = "http://s3.amazonaws.com/circle-static-assets/loading.gif"

# APP HELPER
HIDE_TABLE = "object_list_hidden"

=begin
JOB REQUEST SPECIFIC
=end
NUMBER_OF_DAYS_TO_START_PRODUCTION = 7
NUMBER_OF_DAYS_TO_START_PRODUCTION_SCHEDULING = 4

SHOW_NOTE = true 