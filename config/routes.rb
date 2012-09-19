Projectcamp::Application.routes.draw do
  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  root to: "projects#index"

  resources :pages, only: [:show, :index]

  get "sessions/login", to: "sessions#login", as: :login
  get "sessions/register", to: "sessions#register", as: :register
  
  resources :projects   do
    resources :project_memberships 
    resources :deliverable_items 
  end
  
  resources :packages  do
    resources :deliverable_subcriptions  
  end
  
  resources :deliverables do
    resources :deliverable_components 
  end
  
  resources :deliverable_component_subcriptions do
    resources :drafts 
  end
  
  resources :job_requests 
  
=begin
  SETUP, Create User +  Office Role
=end

  match 'new_employee_creation' => "offices#new_employee_creation", :as => :new_employee_creation
  match 'create_employee' => "offices#create_employee" , :as => :create_employee, :method => :post 
  match 'show_role_for_employee/:employee_id' => "offices#show_role_for_employee" , :as => :show_role_for_employee
  match 'assign_role_for_employee' => "offices#assign_role_for_employee" , :as => :assign_role_for_employee, :method => :post


=begin
  Assigning project membership for employee
=end

  match 'assign_project_membership_role_for/:project_id' => "project_memberships#assign_project_membership_role_for",  :as => :assign_project_membership_role_for, :method => :post
  match 'finalize_membership_assignment' => "projects#finalize_membership_assignment",  :as => :finalize_membership_assignment, :method => :post 
  
=begin
  PRODUCTION MANAGEMENT 
=end

  match 'project_deliverable_items_production_overview/:project_id' => 'deliverable_items#project_deliverable_items_production_overview', :as => :project_deliverable_items_production_overview
  
  
  
=begin 
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:assign_project_membership]
=end
  # from the project
  match 'task_based_project_membership_assignment/:job_request_id/for/:project_id' => "project_memberships#task_based_project_membership_assignment", :as => :task_based_project_membership_assignment
 
  
=begin 
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:concept_planning]
=end
  # from the project
  match 'project_based_concept_planning_fulfillment/:project_id' => "projects#project_based_concept_planning_fulfillment", :as => :project_based_concept_planning_fulfillment
  # short cut from the TASK 
  match 'concept_planning_fulfillment/:job_request_id/for/:project_id' => "projects#concept_planning_fulfillment", :as => :concept_planning_fulfillment
  match 'update_project_concept/:project_id' => "projects#update_project_concept", :as => :update_project_concept, :method => :post 
  match 'finalize_concept' => 'projects#finalize_concept', :as => :finalize_concept, :method => :post 
  
=begin 
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:shoot]
=end
  # from the project
  match 'project_based_shoot_finalization/:project_id' => "projects#project_based_shoot_finalization", :as => :project_based_shoot_finalization
  # short cut from the TASK 
  match 'shoot_finalization/:job_request_id/for/:project_id' => "projects#shoot_finalization", :as => :shoot_finalization
  match 'update_shoot_data/:project_id' => "projects#update_shoot_data", :as => :update_shoot_data, :method => :post
  match 'finalize_shoot_data' => 'projects#finalize_shoot_data', :as => :finalize_shoot_data, :method => :post 
  
=begin
  JOB REQUEST: Start Production
=end
  match 'task_based_deliverable_items_progress/:project_id' => "deliverable_items#task_based_deliverable_items_progress", :as => :task_based_deliverable_items_progress
  match 'task_based_draft_creation_for_component/:deliverable_component_subcription_id' => "drafts#task_based_draft_creation_for_component", :as => :task_based_draft_creation_for_component
  
  match 'task_based_production_team_assignment/:job_request_id/for/:project_id' => 'drafts#task_based_production_team_assignment', :as => :task_based_production_team_assignment
  
=begin
  DRAFT PRODUCTION, not from task 
=end
  # assign production team (by PM)
  match 'production_team_assignment/:draft_id' => 'drafts#production_team_assignment', :as => :production_team_assignment 
  match 'execute_production_team_assignment/:draft_id' => 'drafts#execute_production_team_assignment', :as => :execute_production_team_assignment, :method => :post 
  match 'finalize_production_team_assignment' => 'drafts#finalize_production_team_assignment', :as =>  :finalize_production_team_assignment, :method => :post 
  # assign internal deadline ( by PM ) 
  match 'internal_qc_deadline_assignment/:draft_id' => "drafts#internal_qc_deadline_assignment", :as => :internal_qc_deadline_assignment
  match 'execute_internal_qc_deadline_assignment/:draft_id' => 'drafts#execute_internal_qc_deadline_assignment', :as => :execute_internal_qc_deadline_assignment, :method => :post 
  # propose internal draft finished ( by assigned production ) 
  # approve internal draft ( by QC ) 
  # mark that client has received the draft
  # mark that client has approved + gave feedback 
  # close the draft  ( finalize the draft ) 
  # finalize the component production 
  
end


























