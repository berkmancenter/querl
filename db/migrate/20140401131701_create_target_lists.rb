class CreateTargetLists < ActiveRecord::Migration
  def change
    create_table :target_lists do |t|
      t.string :name
      t.text :description
      t.references :project
      t.timestamps
    end
  end
end
