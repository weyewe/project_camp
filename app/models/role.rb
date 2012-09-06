class Role < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :users, :through => :assignments 
  has_many :assignments 
end
