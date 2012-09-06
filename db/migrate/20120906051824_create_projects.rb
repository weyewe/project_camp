class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title 
      t.integer :package_id
      t.integer :client_id 
      t.integer :creator_id 

      t.boolean :is_fixed_location, :default => true 
      t.boolean :is_fixed_date , :default    => true 

      t.string  :shoot_location
      t.date    :shoot_date
      t.date    :shoot_start_date
      t.date    :shoot_end_date 

      t.date    :internal_deadline
      t.date    :external_deadline 
      
      
      t.boolean :is_deleted  , :default => false 
      t.integer :deleter_id 
      t.boolean :is_finished , :default => false 
      t.integer :finisher_id 
      
      
      

      t.timestamps
    end
  end
end
