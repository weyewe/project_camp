class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.text :overall_feedback 
      t.integer :number
      t.integer :creator_id # who created this draft? 
      t.integer :project_id 
      t.integer :deliverable_component_subcription_id
       
      # basis for reminder  (internal QC) 
      t.date :deadline_date  # project manager has the final say of the deadline
      t.integer :deadline_creator_id 
      
       
      t.boolean :is_qc_approved, :default => false 
      t.integer :qc_approver_id 
      t.date :qc_approval_date 
      
      # basis for reminder -> AE 
      t.date :client_approval_deadline_date  # project manager has the final say of the deadline
      t.integer :client_approval_deadline_creator_id
      
      t.boolean :is_client_approved , :default => false 
      t.integer :client_approval_marker_id 
      t.date :client_approval_date  # when the client returned the shite 
       
      t.boolean :is_finished  , :default => false 
      t.date :finish_date 
      t.integer :finisher_id  # the account executive declares that it is finish
      
      t.timestamps
    end
  end
end
