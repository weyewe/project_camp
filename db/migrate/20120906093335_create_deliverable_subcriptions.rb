class CreateDeliverableSubcriptions < ActiveRecord::Migration
  def change
    create_table :deliverable_subcriptions do |t|
      t.integer :package_id 
      t.integer :deliverable_id 
      
      t.boolean :is_active, :default => true 

      t.timestamps
    end
  end
end
