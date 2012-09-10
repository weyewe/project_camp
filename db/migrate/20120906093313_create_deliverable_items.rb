class CreateDeliverableItems < ActiveRecord::Migration
  def change
    create_table :deliverable_items do |t|
      t.integer :project_id 
      t.integer :deliverable_id 
       
      t.integer :sub_item_quantity
      t.text :project_specific_description
      
      t.boolean :is_basic_deliverable , :default => true # can be basic, or additional
      
      
      
      t.boolean :is_active, :default => true 

      t.timestamps
    end
  end
end
