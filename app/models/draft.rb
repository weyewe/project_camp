class Draft < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :project
  belongs_to :deliverable_component_subcription
end
