class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :survey, :null => false
      t.references :user, :null => false
      t.references :survey_item, :null => false
      t.references :target, :null => false
      t.text :response_text
      t.timestamps
    end
  end
end
