COMPANY_NAME = "potoSys"
COMPANY_TITLE = "potoSys"
=begin
  MODEL CONSTANT
=end
JAKARTA_HOUR_OFFSET = 7 
# in the whole application 
USER_ROLE = { 
  :crew => "Crew",
  :head_project_manager => "HeadProjectManager", # can create projects  
  :project_manager => "ProjectManager",
  :ae => "AccountExecutive" , 
  # Back office roles .. there can be designer editor 
  :production => "Production",
  :post_production => "PostProduction" 
  
}

PROJECT_ROLE = {
  :main_crew => "MainCrew",
  :crew => "Crew", 
  
  :project_manager => "ProjectManager",
  :account_executive => "AccountExecutive", 
  :designer => "Designer",
  :editor => "Editor",
  :post_production => "PostProduction",
  :quality_control => "QualityControl"
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

JOB_REQUEST_SOURCE = {
  # photographers 1-40
  :crew_booking => 1, 
  :crew_day_off => 2 , 
  :transportation_off_day => 3, 
  # account executive  41 - 80
  :follow_up_draft => 41, 
  
  # graphic designer 81 - 120, production team 
  :production_scheduling => 81,
  
  :post_production_scheduling => 131
  
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


