class Project < ActiveRecord::Base
  # attr_accessible :title, :body
  validates_presence_of :title , :external_deadline 
  belongs_to :package 
  
  def self.create_by_user( employee, project_params ) 
  end
end
