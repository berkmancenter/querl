class CreateSurveyItems < ActiveRecord::Migration
  def change
    create_table :survey_items do |t|
      t.string :field_name, :null => false
      t.string :display_text
      t.string :field_type, :null => false
      t.string :field_options
      t.boolean :required, :default => false
      t.references :project, :null => false
      t.timestamps
    end
    
    create_table(:survey_items_surveys, :id => false) do|t|
      t.references :survey_item
      t.references :survey
      t.integer :survey_item_position, :null => false, :default => 0
    end
    
    [:field_name, :display_text, :field_type, :field_options].each do|col|
      add_index :survey_items, col
    end
  end
end
