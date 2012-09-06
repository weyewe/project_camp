class CreateDeliverableComponentSubcriptions < ActiveRecord::Migration
  def change
    create_table :deliverable_component_subcriptions do |t|

      t.timestamps
    end
  end
end
