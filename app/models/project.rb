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
  
  validates_presence_of :title , :external_deadline, :creator_id  , :package_id 
   
  after_create :assign_deliverable_items
  
  
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
  
  
  
  
  def self.active_deliverable_subcriptions
    Project.where(:is_deleted => false  , :is_finished => false ).order("external_deadline ASC, score DESC")
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
      self.deliverable_items.create(:deliverable_id => deliverable_subcription.deliverable_id, 
                :sub_item_quantity => deliverable_subcription.deliverable.sub_item_quantity,
                :project_specific_description => deliverable_subcription.deliverable.description
              )
    end
    
  end
end
