class Package < ActiveRecord::Base
  attr_accessible :title, :description
  
  has_many :projects
  has_many :deliverables, :through => :deliverable_subcriptions 
  has_many :deliverable_subcriptions 
  
end
