class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title 
      t.integer :package_id
      t.integer :client_id 
      t.integer :creator_id 

      t.boolean :is_fixed_date , :default    => false  
      
      t.text :concept , :default => nil
      t.boolean :is_concept_finalized, :default => false  

      t.string  :shoot_location
      t.date    :shoot_date
      t.date    :shoot_start_date
      t.date    :shoot_end_date 
      
      t.text :shoot_data , :default => nil
      t.boolean :is_shoot_finalized, :default => false



      t.date    :internal_deadline
      t.date    :external_deadline  # when they are getting married 
      
      t.boolean :is_membership_assignment_finalized ,:default => false  
      t.date :membership_assignment_finalized_date  
      # when it is switched to true, send email notification to all members 
      
      # only projects that is not is_active
      t.boolean :is_deleted  , :default => false 
      t.integer :deleter_id 
      t.boolean :is_finished , :default => false 
      t.integer :finisher_id 
      t.date :finish_date 
      
      t.integer :score , :default => 0 
      
      
      # tracking the usage? use the user activity. 

      t.timestamps
    end
  end
end
