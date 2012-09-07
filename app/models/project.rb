class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  validates_presence_of :title , :external_deadline 
  belongs_to :package 
  
  has_many :deliverables, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  
  def self.create_by_user( employee, project_params ) 
  end
end
