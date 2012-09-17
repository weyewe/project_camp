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
  match 'project_membership_assignment_from_task/:project_id' => "project_memberships#project_membership_assignment_from_task", :as => :project_membership_assignment_from_task
 
  
=begin 
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:concept_planning]
=end
  # from the project
  match 'project_based_concept_planning_fulfillment/:project_id' => "projects#project_based_concept_planning_fulfillment", :as => :project_based_concept_planning_fulfillment
  # short cut from the TASK 
  match 'concept_planning_fulfillment/:project_id' => "projects#concept_planning_fulfillment", :as => :concept_planning_fulfillment
  match 'update_project_concept/:project_id' => "projects#update_project_concept", :as => :update_project_concept, :method => :post 
  match 'finalize_concept' => 'projects#finalize_concept', :as => :finalize_concept, :method => :post 
  
=begin 
  JOB REQUEST FULFILLMENT  JOB_REQUEST_SOURCE[:shoot]
=end
  # from the project
  match 'project_based_shoot_finalization/:project_id' => "projects#project_based_shoot_finalization", :as => :project_based_shoot_finalization
  # short cut from the TASK 
  match 'shoot_finalization/:project_id' => "projects#shoot_finalization", :as => :shoot_finalization
  match 'update_shoot_data/:project_id' => "projects#update_shoot_data", :as => :update_shoot_data, :method => :post
  match 'finalize_shoot_data' => 'projects#finalize_shoot_data', :as => :finalize_shoot_data, :method => :post 
end


























