class CreateDeliverableItems < ActiveRecord::Migration
  def change
    create_table :deliverable_items do |t|
      t.integer :project_id 
      t.integer :deliverable_id 
       
      t.integer :sub_item_quantity
      t.boolean :is_basic_deliverable , :default => true # can be basic, or additional
      t.text :project_specific_description
      

      t.timestamps
    end
  end
end
