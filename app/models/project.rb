class Project < ActiveRecord::Base
  attr_accessible :title, :external_deadline, :creator_id
  
  belongs_to :package 
  
  has_many :deliverables, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  validates_presence_of :title , :external_deadline, :creator_id  
   
  
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
  
  def self.active_deliverable_subcriptions
    Project.where(:is_deleted => false  , :is_finished => false ).order("external_deadline ASC, score DESC")
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
