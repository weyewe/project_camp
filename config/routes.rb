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
=begin
  SETUP, Create User +  Office Role
=end

  match 'new_employee_creation' => "offices#new_employee_creation", :as => :new_employee_creation
  match 'create_employee' => "offices#create_employee" , :as => :create_employee, :method => :post 
  match 'show_role_for_employee/:employee_id' => "offices#show_role_for_employee" , :as => :show_role_for_employee
  match 'assign_role_for_employee' => "offices#assign_role_for_employee" , :as => :assign_role_for_employee, :method => :post

end
