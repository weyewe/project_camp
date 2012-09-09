class CreateDeliverableComponents < ActiveRecord::Migration
  def change
    create_table :deliverable_components do |t|
      t.string :name 
      t.text :description 
      t.boolean :is_active , :default => false 
      
      t.integer :deliverable_id 
      
      # over here, we assume that it is by default to be true.. in fact, it can be false.
      # but still, the requirement might be different from one photography to another 
      t.boolean :is_production_element, :default => true 
      t.boolean :is_post_production_element, :default => true 
      
      
      t.timestamps
    end
  end
end
