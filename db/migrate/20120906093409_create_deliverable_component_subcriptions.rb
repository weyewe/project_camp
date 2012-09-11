class CreateDeliverableComponentSubcriptions < ActiveRecord::Migration
  def change
    create_table :deliverable_component_subcriptions do |t|
      t.integer :deliverable_item_id
      t.integer :deliverable_component_id 
      
      t.boolean :is_production_started, :default => false 
      t.date :production_start_date
      t.boolean :is_production_finished , :default => false 
      t.date :production_finish_date
      
      
      t.boolean :is_post_production_started, :default => false 
      t.date :post_production_start_date
      t.boolean :is_post_production_finished, :default => false 
      t.date :post_production_finish_date 
      
      t.boolean :is_active, :default => true 

      t.timestamps
    end
  end
end
