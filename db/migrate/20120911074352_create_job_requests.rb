class CreateJobRequests < ActiveRecord::Migration
  def change
    create_table :job_requests do |t|
      t.integer :user_id 
      t.integer :creator_id 
      
      t.integer :project_id
      # t.integer :deliverable_component_subcription_id 
      t.integer :draft_id 
      
      
      t.text :description # (content) 
      t.date :start_date  # -> assigned by the PM  
      t.date :deadline_date # -> assigned by the PM 
      t.date :finish_date # only the assignee that can declare that it is finished 
      
      t.boolean :is_finished, :default => false 
      t.boolean :is_canceled, :default => false 
      
      
      t.integer :prev_job_request_id  
      t.integer :job_request_source, :default => JOB_REQUEST_SOURCE[:concept_planning]  
      
      t.timestamps
    end
  end
end
