class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :description
      t.references :project
      t.references :target_list
      t.string :behavior
      t.timestamps
    end
  end
end
