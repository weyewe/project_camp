class CreateDeliverableComponents < ActiveRecord::Migration
  def change
    create_table :deliverable_components do |t|

      t.timestamps
    end
  end
end
