class CreateDeliverables < ActiveRecord::Migration
  def change
    create_table :deliverables do |t|
      t.string :name
      t.text :description 
      
      t.boolean :has_sub_item , :default => false 
      t.string :sub_item_name 
      t.integer :sub_item_quantity 
      
      t.boolean :is_deleted, :default => false 
       
      t.timestamps
    end
  end
end
