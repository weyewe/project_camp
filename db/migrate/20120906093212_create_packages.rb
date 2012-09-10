class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :title
      t.text :description 
      
      t.boolean :is_active, :default  => true  
      
      t.timestamps
    end
  end
end
