class Project < ActiveRecord::Base
  attr_accessible :title, :external_deadline, :creator_id, :package_id , 
                  :is_fixed_date, 
                  :shoot_location, :shoot_date, :shoot_start_date, :shoot_end_date , 
                  :internal_deadline,
                  :client_id 
  
  belongs_to :package 
  
  has_many :deliverables, :through => :deliverable_items 
  has_many :deliverable_items 
  
  has_many :project_memberships 
  has_many :users, :through => :project_memberships
  
  has_many :deliverable_component_subcriptions
  
  validates_presence_of :title , :external_deadline, :creator_id  , :package_id 
   
  # after_create :assign_deliverable_items
  
  
=begin
  Object Creation
=end
  def self.create_object( employee, object_params ) 
    object_params[:external_deadline] = Project.parse_date(object_params[:external_deadline])
    object_params[:creator_id] = employee.id 
    new_object = self.new object_params 
    if not employee.has_role?(:head_project_manager) 
      return new_object 
    end
    
    if new_object.external_deadline.nil? or new_object.external_deadline <= Time.now.to_date 
      new_object.errors.add(:external_deadline , "The format is dd/mm/yyyy and the external deadline must be later than today" )  
      return new_object
    end
    new_object.save 
    if new_object.persisted? 
      new_object.assign_deliverable_items
    end
    
    return new_object
  end
  
  
  
=begin
  Object Update
=end
  def update_with_attributes( employee, object_params  )
    # if employee is not admin 
    # if employee is not the assigned HEAD PM 
      # return nil 
    # assign_attributes
    
    object_params[:external_deadline] = Project.parse_date( object_params[:external_deadline] ) 
    object_params[:shoot_date] = Project.parse_date( object_params[:shoot_date]  ) 
    object_params[:shoot_start_date] = Project.parse_date( object_params[:shoot_start_date]  ) 
    object_params[:shoot_end_date] =  Project.parse_date( object_params[:shoot_end_date]  ) 
    
    
    self.assign_attributes( object_params ) 
    if not self.internal_deadline.nil? and self.internal_deadline > self.external_deadline
      self.errors.add(:internal_deadline , "The internal deadline should not be later than external deadline" ) 
    end
    
    if not self.shoot_date.nil? and not self.shoot_start_date.nil? and not self.shoot_end_date.nil?
      if self.shoot_date < self.shoot_start_date or self.shoot_date > self.shoot_end_date  
        self.errors.add(:shoot_date , "Shoot date must be between starting date and ending date" ) 
        self.errors.add(:shoot_start_date , "Shoot start date can't be later than shoot  date" )
        self.errors.add(:shoot_end_date , "Shoot ending date can't be earlier than shoot date" )
      end 
      
    end
    
    if self.is_fixed_date == true 
      if self.shoot_date.nil? 
        self.errors.add(:is_fixed_date , "Shoot date must be specified" ) 
      end
    end
      
      
      
    if self.errors.messages.length == 0  
      self.save
    else
      return self
    end
    
    # if not fixed date, allow shoot date, start date, end date to be empty
    # if it is fixed, show error  if they are empty 
    
    # auto update job assignment for assigned crews 
    
  end 
  
  def active_deliverable_items
    self.deliverable_items.joins(:deliverable).where(:is_active => true ).order("created_at DESC")
  end
  

  def self.active_projects
    Project.where(:is_deleted => false  , :is_finished => false ).order("external_deadline ASC, score DESC")
  end

=begin
  ASSIGNING PROJECT MEMBERSHIP 
=end
  def add_project_membership( employee,  project_collaborator,  project_role  )
    if not employee.has_role?(:admin)
      return nil
    end

    project_membership = ProjectMembership.find(:first, :conditions => {
      :user_id => project_collaborator.id ,
      :project_id => self.id
    })

    if project_membership.nil?
      project_membership = ProjectMembership.create(
                      :user_id => project_collaborator.id ,
                      :project_id => self.id 
                  )
    end

    project_membership.add_roles( [project_role] )
  end

  def remove_project_membership(employee, project_collaborator,  project_role  )
    if not employee.has_role?(:admin)
      return nil
    end

    project_membership = ProjectMembership.find(:first, :conditions => {
      :user_id => project_collaborator.id ,
      :project_id => self.id
    })

    if project_membership.nil?
      return nil
    end
 
    project_membership.remove_project_role( project_role )   
  end

  def project_memberships_for_project_role( project_role )
    project_membership_id_list =  self.project_memberships.map{|x| x.id }

    ProjectAssignment.where(:project_role_id => project_role.id, 
            :project_membership_id => project_membership_id_list)

  end
  
  def finalize_project_membership_assignment(employee)
    if not employee.has_role?(:head_project_manager)
      return nil
    end
    
    if self.is_core_project_member_complete?
      self.is_membership_assignment_finalized = true 
      self.membership_assignment_finalized_date = Time.now.to_date 
      self.save 
      self.create_on_project_member_assignment_finalization_job_requests(employee)
      self.create_project_member_assignment_notification 
    end
    #  send email to all project members 
  end

  def is_core_project_member_complete?
    project_membership_id_list = self.project_memberships.map{|x| x.id }
    project_role_id_list  = ProjectAssignment.
                          where(:project_membership_id =>project_membership_id_list ).
                          map{|x| x.project_role_id} 
    # PM  MainCrew  Crew  AE  QC
    
    complete_project_role_id_list = ProjectRole.where(:name => [
      PROJECT_ROLE[:main_crew], 
      PROJECT_ROLE[:project_manager],
      PROJECT_ROLE[:account_executive] ,
      PROJECT_ROLE[:quality_control]
      ]).map{|x| x.id } 
      
    complete_project_role_id_list.each do |x|
      if not project_role_id_list.include?(x)
        return false
      end
    end
    
    return true
  end  
  
  def create_project_member_assignment_notification
    # send notification email 
  end
  
  def project_members_with_project_role(project_role_symbol_list)
    project_role_name_list = []
    project_role_symbol_list.each do |projecy_role_symbol|
      project_role_name_list << PROJECT_ROLE[projecy_role_symbol]
    end
    
    project_role_id_list = ProjectRole.where(:name =>  project_role_name_list).map{|x| x.id }
    user_id_list = User.joins(:project_memberships => [:project_assignments]).where(
      :project_memberships => { 
          :project_id => self.id ,
          :project_assignments => {:project_role_id => project_role_id_list}
      }
    ).map{|x| x.id }
    
    User.where(:id => user_id_list.uniq )
  end
  
  def create_on_project_member_assignment_finalization_job_requests(employee) 
    
    self.project_members_with_project_role( [:main_crew] ).each do |x|
      job_request = JobRequest.new 
      job_request.project_id = self.id 
      job_request.user_id = x.id 
      job_request.start_date = Time.now.to_date 
      job_request.deadline_date = self.shoot_start_date 
      job_request.creator_id = employee.id 
      job_request.job_request_source  = JOB_REQUEST_SOURCE[:concept_planning] 
      job_request.save 
    end 
    
    self.project_members_with_project_role([:crew, :main_crew]).each do |x|
      job_request = JobRequest.new 
      job_request.project_id = self.id 
      job_request.user_id = x.id 
      job_request.start_date = self.shoot_start_date 
      job_request.deadline_date = self.shoot_end_date 
      job_request.creator_id = employee.id 
      job_request.job_request_source  = JOB_REQUEST_SOURCE[:shoot] 
      job_request.save
    end    
  end
  
=begin
  PROJECT CONCEPT
=end  
  def update_project_concept(employee, project_concept )
    if not employee.has_project_role_symbol?(self, :main_crew)
      puts "NO AUTHORIZATION \n"*10
      self.errors.add(:authorization , "Doesn't have proper authorization" );
      return self 
    end
    
    self.concept = project_concept 
    
    if project_concept.nil? or project_concept.length == 0
      puts "THE CONCEPT LENGTH is 0 \n"*10
      self.errors.add(:concept , "Must not be empty" );
      return self 
    end
    
    
    self.save
    puts "Save is successful"
    return self  
  end
  
  
  
  
  
  
  
  
=begin
  Utility and Callbacks
=end
  
  
  
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
  
  def assign_deliverable_items
    # t.integer  "default_sub_item_quantity"
    # t.integer  "final_sub_item_quantity"
    # t.text     "project_specific_description"
    self.package.deliverable_subcriptions.each do |deliverable_subcription|
      deliverable_item = self.deliverable_items.create(:deliverable_id => deliverable_subcription.deliverable_id, 
                :sub_item_quantity => deliverable_subcription.deliverable.sub_item_quantity,
                :project_specific_description => deliverable_subcription.deliverable.description
              )
      deliverable_item.assign_deliverable_component_subcription 
    end
    
  end
end
