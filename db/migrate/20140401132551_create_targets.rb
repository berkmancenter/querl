class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.string :name, :null => false
      t.string  :display_text,   :limit => 1024
      t.text  :description
      t.string  :link_text
      t.string :target_type
      t.references :target_list
      t.timestamps
    end
  end
end
