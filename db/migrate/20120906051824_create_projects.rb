class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title 
      t.integer :package_id
      t.integer :client_id 
      t.integer :creator_id 

      t.boolean :is_fixed_date , :default    => false  

      t.string  :shoot_location
      t.date    :shoot_date
      t.date    :shoot_start_date
      t.date    :shoot_end_date 

      t.date    :internal_deadline
      t.date    :external_deadline  # when they are getting married 
      
      
      # only projects that is not is_active
      t.boolean :is_deleted  , :default => false 
      t.integer :deleter_id 
      t.boolean :is_finished , :default => false 
      t.integer :finisher_id 
      
      t.integer :score , :default => 0 
      
      
      # tracking the usage? use the user activity. 

      t.timestamps
    end
  end
end
